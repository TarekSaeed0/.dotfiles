#!/bin/zsh

__prompt_virtual_environment() {
	if [[ -n "$VIRTUAL_ENV_PROMPT" ]]; then
		print "  $VIRTUAL_ENV_PROMPT "
	fi
}
