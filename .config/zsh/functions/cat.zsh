#!/bin/zsh

function cat() {
	if (( $+commands[bat] )); then
		bat -P "$@"
	else
		command cat "$@"
	fi
}
