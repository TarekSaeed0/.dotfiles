#!/bin/zsh

cat() {
	if (( $+commands[bat] )); then
		bat -P "$@"
	else
		command cat "$@"
	fi
}