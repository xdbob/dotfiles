#!/bin/bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z $PWD ]; then
	echo Could not detect script location...
	exit 1
fi

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

cd $PWD
echo Updating submodules.
git submodule update --init --recursive
ErrExit

echo vim setup
cd vim
echo Installing h2cppx dependancies.
sh ./h2cppx-postinstall.sh
ErrExit

echo Compiling YouCompleteMe...
sh ./ycm-compile.sh
ErrExit
cd ..

# Backing up config files
Backup "${HOME}/.zshrc"
Backup "${HOME}/.shellrc"
Backup "${HOME}/.vim"
Backup "${HOME}/.vimrc"

# Installing the new files
touch "${HOME}/.customrc"
ErrExit
echo "Installing shellrc"
ln -s "${PWD}/shellrc" "${HOME}/.shellrc"
ErrExit
echo "Installing zshrc"
ln -s "${PWD}/zshrc" "${HOME}/.zshrc"
ErrExit
echo "Installing vim directory"
ln -s "${PWD}/vim" "${HOME}/.vim"
echo "Installing vimrc"
ln -s "${PWD}/vim/vimrc" "${HOME}/.vimrc"
ErrExit

exit 0
