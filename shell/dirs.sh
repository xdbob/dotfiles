if [ -x /usr/bin/dircolors ]; then
	if [ -r $HOME/.dir_colors ]; then
		eval "$(dircolors $HOME/.dir_colors)"
	else
		eval "$(dircolors)"
	fi
fi
