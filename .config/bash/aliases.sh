#!/bin/bash

alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"

if command -v dircolors &>/dev/null; then
	if [ -r "$HOME/.dircolors" ]; then
		eval "$(dircolors -b "$HOME/.dircolors")"
	else
		eval "$(dircolors -b)"
	fi

	eval "$(dircolors -b <(echo "DIR 1;38;2;148;226;213"))"

	alias dir="dir --color=auto"
	alias vdir="vdir --color=auto"

	alias grep="grep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias egrep="egrep --color=auto"
fi
