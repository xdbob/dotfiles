export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin:$HOME/.bin
export EDITOR='vim'
export NNTPSERVER=news.epita.fr
export HISTFILE=$HOME/.history
export HISTSIZE=$((2 ** 15 - 1))
export VIRSH_DEFAULT_CONNECT_URI=qemu:///system

if which nproc &> /dev/null && [ $(nproc) -gt 1 ]; then
	export MAKEFLAGS="-j$(($(nproc) - 1))"
fi

CCACHEDIR=/usr/lib/ccache/bin
if [ -d $CCACHEDIR ]; then
	export PATH=$CCACHEDIR:$PATH
fi
