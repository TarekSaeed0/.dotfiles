#!/bin/zsh

ls() {
	if [[ -t 1 ]]; then
	  if (( $+commands[exa] )); then
			exa -lgM --git --color=always --icons=always "$@" | sed "s///g" | sed "s///g"
		else
			command ls -lsh --color=auto "$@" | tail -n +2
		fi
	else
		command ls "$@"
	fi
}