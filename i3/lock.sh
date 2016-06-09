#!/bin/bash

scrot /tmp/screen.png
convert /tmp/screen.png -blur 0x5 /tmp/blur.png
i3lock -i /tmp/blur.png

exit 0;
