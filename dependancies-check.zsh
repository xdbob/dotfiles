#!/bin/zsh

autoload -U colors && colors
ERR=0

function status() {
	if [ $? -eq 0 ]; then
		print "Is $1 present ? $fg[green]yes${reset_color}"
	else
		print "$fg_bold[red]$1 was NOT FOUND$reset_color" >&2
		ERR=$(($ERR + 1))
	fi
}

function print_name() {
	if [ -z $2 ]; then
		echo -n "$1"
	else
		echo -n "$2"
	fi
}

function python_look() {
	local name=`print_name $1 $2`
	python -c "import $1" &> /dev/null
	status $name
}

function look() {
	local name=`print_name $1 $2`
	which "$1" &> /dev/null
	status $name
}

# TODO: detect ttf-hack

look scrot
look convert imagemagick
look feh
look j4-dmenu-desktop
look xset xorg-xset
look xss-lock
look compton
look termite
look i3lock
look pulseaudio
look pulseaudio-ctl
look python2
look python
look pip2
look go
look xbuild mono
look clang
python_look i3pystatus
python_look alsaaudio python-pyalsaaudio
python_look dbus python-dbus
python_look psutil python-psutil
python_look netifaces python-netifaces
python_look bs4 python-beautifulsoup4
python_look cssselect python-cssselect
python_look lxml python-lxml
python_look pywapi python-pywapi
python_look basiciw python-basiciw
python_look colour python-colour

if [ $ERR -eq 0 ]; then
	print "\n$fg_bold[green]All dependancies are present$reset_color"
	return 0
else
	echo "\n$fg_bold[red]$ERR dependancies where not found$reset_color" >& 2
	return 1
fi
