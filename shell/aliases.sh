alias xclip='xclip -i -selection clipboard'
alias gwall='gcc -Wall -Wextra -Werror -std=c99 -pedantic -g3'
alias ls='ls --classify --tabsize=0 --literal --color --show-control-chars --human-readable'
alias cp='cp --interactive'
alias mv='mv --interactive'
alias rm='rm --interactive'
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias df='df --human-readable'
alias du='du --human-readable'
alias gpg='gpg2'
alias grep='grep --color --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias less='less -R'
alias ssh='TERM=xterm-256color ssh'
alias klog='dmesg --color=always | less -R'
alias mutt='neomutt'

function mailsync() {
	if [ $# -eq 0 ]; then
		mailsync -a
	else
		maildir-notmuch-sync pre ~/.mail/gmail && \
			mbsync $@; \
			notmuch new && \
			maildir-notmuch-sync post ~/.mail/gmail
	fi
}
