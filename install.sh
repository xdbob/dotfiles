#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z $dir ]; then
	echo Could not detect script location...
	exit 1
fi

tmpdir="$( mktemp -d )"
backdir="dotfiles-back"
mkdir -p ${tmpdir}/${backdir}

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
		if [ -L "$1" ]; then
			rm -f "${1}"
			echo "Symlink (deleted...)"
		else
			mv ${1} ${tmpdir}/${backdir}
			ErrExit
			echo "Done"
		fi
	else
		echo "Nothing to do"
	fi
	return 0
}

cd $dir
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
cd $dir

mkdir -p "${HOME}/.gnupg"
mkdir -p "${HOME}/.config/systemd/user"
mkdir -p "${HOME}/.i3"

# Backing up config files
Backup "${HOME}/.zshrc"
Backup "${HOME}/.shellrc"
Backup "${HOME}/.vim"
Backup "${HOME}/.vimrc"
Backup "${HOME}/.gnupg/gpg.conf"
Backup "${HOME}/.gnupg/gpg-agent.conf"
Backup "${HOME}/.i3/config"
Backup "${HOME}/.i3/lock.sh"
Backup "${HOME}/.i3/status.py"
Backup "${HOME}/.Xdefaults"
Backup "${HOME}/.signature"
Backup "${HOME}/.oh-my-zsh"
Backup "${HOME}/.gitconfig"
Backup "${HOME}/.dir_colors"
Backup "${HOME}/.zsh"

# Generating backup archives
cd $tmpdir
echo "Generating backup archive..."
tar cjvf ${backdir}.tar.bz2 ${backdir}
ErrExit
echo "Copying ${backdir}.tar.bz2 to ${HOME}"
mv ${backdir}.tar.bz2 ${HOME}
ErrExit
cd $dir

# Installing the new files
touch "${HOME}/.customrc"
ErrExit
echo "Installing shellrc"
ln -s "${dir}/shellrc" "${HOME}/.shellrc"
ErrExit
echo "Installing zshrc"
ln -s "${dir}/zshrc" "${HOME}/.zshrc"
ErrExit
echo "Installing .zsh"
ln -s "${dir}/zsh" "${HOME}/.zsh"
ErrExit
echo "Installing vim directory"
ln -s "${dir}/vim" "${HOME}/.vim"
ErrExit
echo "Installing vimrc"
ln -s "${dir}/vim/vimrc" "${HOME}/.vimrc"
ErrExit
echo "Installing gpg.conf"
ln -s "${dir}/gnupg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
ErrExit
echo "Installing gpg-agent.conf"
ln -s "${dir}/gnupg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
ErrExit
echo "Installing i3 config"
ln -s "${dir}/i3/config" "${HOME}/.i3/config"
ErrExit
echo "Installling i3 status config"
ln -s "${dir}/i3/status.py" "${HOME}/.i3/status.py"
ErrExit
echo "Installing lock.sh"
ln -s "${dir}/i3/lock.sh" "${HOME}/.i3/lock.sh"
ErrExit
echo "Installing Xdefaults"
ln -s "${dir}/Xdefaults" "${HOME}/.Xdefaults"
ErrExit
echo "Installing signature"
ln -s "${dir}/signature" "${HOME}/.signature"
ErrExit
echo "Installing gitconfig"
ln -s "${dir}/gitconfig" "${HOME}/.gitconfig"
ErrExit
echo "Installing dir_colors"
ln -s "${dir}/dir_colors" "${HOME}/.dir_colors"
ErrExit

rm -rf $tmpdir
exit 0
