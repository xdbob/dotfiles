autoload -U compaudit compinit bashcompinit

comp_file="${HOME}/.cache/zcompdump"
cache_dir="$HOME/.cache"
version_file="$cache_dir/zsh_version"
if [ ! -f "$version_file" ] || [ "${ZSH_VERSION}" != "$(cat $version_file)" ]; then
	rm -f -- "$comp_file"
	mkdir -p "$cache_dir"
	echo -n "${ZSH_VERSION}" > "$version_file"
fi
compinit -i -d "$comp_file"
unset version_file
unset comp_file
unset cache_dir

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

WORDCHARS=''

zmodload -i zsh/complist

zstyle ':completion:*' list-colors ''

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
if [ "$OSTYPE[0,7]" = "solaris" ]
then
	zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm"
else
	zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
fi

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
	adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
	clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
	gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
	ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
	named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
	operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
	rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
	usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# Load bash system's bash completion
bashcompinit
function load_bash_completion() {
	local tool="$1"
	if whence -p "$tool" &>/dev/null; then
		for compdir in /usr/share/bash-completion/completions /etc/bash_completion.d; do
			if [[ -f "$compdir/$tool" ]]; then
				source "$compdir/$tool"
				break
			fi
		done
	fi
}

# the `perf` completion script is doing weird magic voodo and breaks whatever
# bash-completion script loaded before… we shall load it first then -_-
load_bash_completion perf
load_bash_completion woob
