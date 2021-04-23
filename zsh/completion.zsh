autoload -U compaudit compinit bashcompinit

fpath+="${HOME}/.zsh/zsh-completions/src"

function load_and_generate_cache() {
	local cache_dir="$HOME/.cache"
	local comp_file="$cache_dir/zcompdump"
	local version_file="$cache_dir/zsh_version"
	local cache_version="${ZSH_VERSION}+1"
	if [[ ! -f "$version_file" ]] ||
	   [[ "x${cache_version}" != "x$(cat $version_file)" ]]; then
		rm -f -- "$comp_file"
		mkdir -p "$cache_dir"
		echo -n "${cache_version}" > "$version_file"
	fi
	compinit -i -d "$comp_file"
}

load_and_generate_cache
unset -f load_and_generate_cache

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
	emulate -L bash
	local tool="$1"
	if whence -p "$tool" &>/dev/null; then
		for compdir in /etc/bash_completion.d /usr/share/bash-completion/completions; do
			if [[ -f "$compdir/$tool" ]]; then
				source "$compdir/$tool"
				break
			fi
	done
	fi
}

load_bash_completion woob
