#!/bin/bash

for component in cd.sh ls.sh cat.sh retry.sh dotfiles.sh; do
	if [ -r "$XDG_CONFIG_HOME/bash/functions/$component" ]; then
		. "$XDG_CONFIG_HOME/bash/functions/$component"
	fi
done
