#!/bin/bash

ls() {
	if [ -t 1 ]; then
		if command -v exa &>/dev/null; then
			exa -lgM --git --color=always --icons=always "$@" | sed "s///g" | sed "s///g"
		else
			command ls -lsh --color "$@" | tail -n +2
		fi
	else
		command ls "$@"
	fi
}
