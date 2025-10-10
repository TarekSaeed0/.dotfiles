#!/bin/bash

for completion in dotfiles create_project; do
	if [ -r "$XDG_CONFIG_HOME/bash/completions/${completion}.sh" ]; then
		. "$XDG_CONFIG_HOME/bash/completions/${completion}.sh"
	fi
done

if command -v flutter &>/dev/null; then
	eval "$(flutter bash-completion)"
fi

if command -v ng &>/dev/null; then
	source <(ng completion script)
fi
