#!/bin/bash

for function in cd ls cat retry dotfiles create_project; do
	if [ -r "$XDG_CONFIG_HOME/bash/functions/${function}.sh" ]; then
		. "$XDG_CONFIG_HOME/bash/functions/${function}.sh"
	fi
done
