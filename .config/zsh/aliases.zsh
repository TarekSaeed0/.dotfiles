#!/bin/zsh

alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"

if (( $+commands[dircolors] )); then
	if [[ -r "$HOME/.dircolors" ]]; then
		eval "$(dircolors -b "$HOME/.dircolors")"
	else
		eval "$(dircolors -b)"
	fi

	eval "$(dircolors -b <(print -r -- 'DIR 1;38;2;148;226;213'))"

	alias dir="dir --color=auto"
	alias vdir="vdir --color=auto"

	alias grep="grep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias egrep="egrep --color=auto"
fi

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

if [[ -n "$NVIM" ]]; then
	if (( $+commands[nvr] )); then
		alias nvim="nvr -l"
		export EDITOR='nvr -l'
		export MANPAGER='nvr -l +Man! -'
	fi
fi