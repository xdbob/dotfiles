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
Backup "${HOME}/.config/systemd/user/gpg-agent.service"
Backup "${HOME}/.i3/config"
Backup "${HOME}/.i3/i3status.conf"
Backup "${HOME}/.i3/lock.sh"
Backup "${HOME}/.Xdefaults"
Backup "${HOME}/.signature"
Backup "${HOME}/.oh-my-zsh"
Backup "${HOME}/.gitconfig"

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
echo "Installing Oh My Zsh"
ln -s "${dir}/oh-my-zsh" "${HOME}/.oh-my-zsh"
echo "Installing vim directory"
ln -s "${dir}/vim" "${HOME}/.vim"
echo "Installing vimrc"
ln -s "${dir}/vim/vimrc" "${HOME}/.vimrc"
ErrExit
echo "Installing gpg.conf"
ln -s "${dir}/gnupg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
ErrExit
echo "Installing gpg-agent.conf"
ln -s "${dir}/gnupg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
ErrExit
echo "Installing gpg-agent.service"
cp "${dir}/gnupg/gpg-agent.service" "${HOME}/.config/systemd/user/gpg-agent.service"
ErrExit
echo "Installing i3 config"
ln -s "${dir}/i3/config" "${HOME}/.i3/config"
ErrExit
echo "Installling i3 status config"
ln -s "${dir}/i3/i3status.conf" "${HOME}/.i3/i3status.conf"
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


echo "Enabling gpg-agent.service"
systemctl --user enable gpg-agent.service
ErrExit
echo "Killing all instances of gpg-agent"
killall gpg-agent
echo "Starting gpg-agent.service"
systemctl --user start gpg-agent.service
ErrExit

rm -rf $tmpdir
exit 0
