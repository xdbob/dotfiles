#!/bin/sh
# Start i3.service if needed for the current x environment

if systemctl --user is-active graphical-session.target &> /dev/null; then
	echo "graphical-session.target is already running ! Aborting" >&2
	exit 1
fi

I3SOCK="$(i3 --get-socketpath)"
if [ ! -S "$I3SOCK" ]; then
	echo "Could not find i3 socket" >&2
	exit 1
fi

export I3SOCK

systemctl --user import-environment DISPLAY XAUTHORITY I3SOCK XDG_SESSION_ID
systemctl --user start i3.service
