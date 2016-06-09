#!/bin/sh

ErrExit () {
	if [ "$?" -ne "0" ]; then
		while true; do
			read -p "ERROR, do you wish to continue ?" yn
			case $yn in
				[YyOo]* ) break;;
				[Nn]* ) exit 1;;
			esac
		done
	fi
}

Backup () {
	echo -n "Backing up $1 ... "
	if [ -e "$1" ]; then
		if [ -e "{$1}.back" ]; then
			echo "The file ${1}.back already exists..."
			exit 1
		else
			mv "$1" "${1}.back"
			ErrExit
			echo " Done"
		fi
	else
		rm -f "${1}"
		echo "Nothing to do"
	fi
	return 0
}

PWD=$(pwd)

# Backing up config files
Backup "${HOME}/.zshrc"
ErrExit
Backup "${HOME}/.shellrc"
ErrExit

# Installing the new files
touch "${HOME}/.customrc"
ErrExit
echo "Installing shellrc"
ln -s "${PWD}/shellrc" "${HOME}/.shellrc"
ErrExit
echo "Installing zshrc"
ln -s "${PWD}/zshrc" "${HOME}/.zshrc"
ErrExit
