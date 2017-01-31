export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin
export EDITOR='vim'
export NNTPSERVER=news.epita.fr
export HISTFILE=$HOME/.history
export HISTSIZE=$((2 ** 15 - 1))

if which nproc &> /dev/null && [ $(nproc) -gt 1 ]; then
	export MAKEFLAGS="-j$(($(nproc) - 1))"
fi
