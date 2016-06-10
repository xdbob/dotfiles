#!/bin/bash

scrot /tmp/screen.png
if [ "$1" = "screen" ]; then
	i3lock -i /tmp/screen.png -f
else
	convert /tmp/screen.png -blur 0x5 /tmp/blur.png
	i3lock -i /tmp/blur.png
fi
exit 0;
