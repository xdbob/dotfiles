#!/bin/bash

scrot /tmp/screen.png
if [ "$1" = "screen" ]; then
	i3lock -i /tmp/screen.png -f
else
	i3lock -n -i /tmp/screen.png &
	LOCK=$!
	convert /tmp/screen.png -filter Gaussian -resize 50% \
		-define filter:sigma=2.5 -resize 200% /tmp/blur.png
	kill -9 $LOCK
	i3lock -i /tmp/blur.png -f
fi
exit 0
