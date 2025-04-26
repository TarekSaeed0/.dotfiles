#!/bin/bash

# If not running interactively, don't do anything

case $- in
*i*) ;;
*) return ;;
esac

# Add user local bin to PATH

if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

# Source bash components

for component in multiplexer functions aliases misc prompt; do
	if [ -r "$XDG_CONFIG_HOME/bash/$component.sh" ]; then
		. "$XDG_CONFIG_HOME/bash/$component.sh"
	fi
done

if [ -r "/usr/share/bash-completion/bash_completion" ]; then
	if [ -r "$XDG_CONFIG_HOME/bash/completions.sh" ]; then
		. "$XDG_CONFIG_HOME/bash/completions.sh"
	fi
fi
