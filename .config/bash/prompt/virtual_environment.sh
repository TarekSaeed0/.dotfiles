#!/bin/bash

__prompt_virtual_environment() {
	if [ -n "$VIRTUAL_ENV_PROMPT" ]; then
		echo -ne " $VIRTUAL_ENV_PROMPT "
	fi
}
