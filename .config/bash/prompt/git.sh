#!/bin/bash

__prompt_git() {
	if git branch --no-color &>/dev/null; then
		echo -e " \001\e[1D\002 $(git branch --no-color | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/') "
	fi
}
