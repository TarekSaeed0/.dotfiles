#!/bin/bash

# If not running interactively, don't do anything

case $- in
*i*) ;;
*) return ;;
esac

# Source bash components

echo "" >"$HOME/bash.log"
for component in multiplexer functions aliases misc prompt; do
	if [ -r "$XDG_CONFIG_HOME/bash/$component.sh" ]; then
		start_time=$(date +%s.%N)
		. "$XDG_CONFIG_HOME/bash/$component.sh"
		end_time=$(date +%s.%N)
		elapsed_time=$(awk \
			-v start="$start_time" \
			-v end="$end_time" \
			'BEGIN { print end - start }')
		echo "$component took $elapsed_time seconds" >>"$HOME/bash.log"
	fi
done

if [ -r "/usr/share/bash-completion/bash_completion" ]; then
	if [ -r "$XDG_CONFIG_HOME/bash/completions.sh" ]; then
		start_time=$(date +%s.%N)
		. "$XDG_CONFIG_HOME/bash/completions.sh"
		end_time=$(date +%s.%N)
		elapsed_time=$(awk \
			-v start="$start_time" \
			-v end="$end_time" \
			'BEGIN { print end - start }')
		echo "bash_completion took $elapsed_time seconds" >>"$HOME/bash.log"
	fi
fi
