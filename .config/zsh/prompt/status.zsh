#!/bin/zsh

__prompt_status_precmd() {
	__prompt_status_exit_code="$?"
}

function __prompt_status() {
	if [[ "$__prompt_status_exit_code" -ne 0 ]]; then
		print "%B%F{#f38ba8}$__prompt_status_exit_code  %b%F{#6c7086}"
	fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __prompt_status_precmd
