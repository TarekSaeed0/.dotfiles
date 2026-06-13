#!/bin/zsh

function diff() {
	if (( $+commands[delta] )); then
		delta "$@"
	else
		command diff "$@"
	fi
}
