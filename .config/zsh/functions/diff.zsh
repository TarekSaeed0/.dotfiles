#!/bin/zsh

diff() {
	if (( $+commands[delta] )); then
		delta "$@"
	else
		command diff "$@"
	fi
}