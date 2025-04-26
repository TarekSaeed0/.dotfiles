#!/bin/bash

for completion in dotfiles create_project; do
	if [ -r "$XDG_CONFIG_HOME/bash/completions/${completion}.sh" ]; then
		. "$XDG_CONFIG_HOME/bash/completions/${completion}.sh"
	fi
done
