#!/bin/zsh

autoload -U colors && colors
ERR=0
function look() {
	if [ -z $2 ]; then
		NAME=$1
	else
		NAME=$2
	fi
	which "$1" > /dev/null
	if [ $? -eq 0 ]; then
		print "Is $NAME present ? $fg[green]yes${reset_color}"
	else
		print "$fg_bold[red]$NAME was NOT FOUND$reset_color" >&2
		ERR=$(($ERR + 1))
	fi
}

# TODO: detect ttf-hack
# TODO: detect pythons modules

look scrot
look convert imagemagick
look feh
look j4-dmenu-desktop
look xset xorg-xset
look xss-lock
look unclutter
look compton
look termite
look i3lock
look pulseaudio
look i3pystatus
look python2
look python
look pip2

if [ $ERR -eq 0 ]; then
	print "\n$fg_bold[green]All dependancies are present$reset_color"
	return 0
else
	echo "\n$fg_bold[red]$ERR dependancies where not found$reset_color" >& 2
	return 1
fi
