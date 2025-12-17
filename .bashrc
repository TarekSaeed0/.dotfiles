#!/bin/bash

# If not running interactively, don't do anything

case $- in
*i*) ;;
*) return ;;
esac

echo "" >"$XDG_STATE_HOME/bash/performance.log"

performance_timer_start() {
	date +%s.%N
}

performance_timer_end() {
	local start_time="$1"
	local end_time=$(date +%s.%N)
	local elapsed_time=$(awk \
		-v start="$start_time" \
		-v end="$end_time" \
		'BEGIN { print end - start }')
	echo "$2 took $elapsed_time seconds" >>"$XDG_STATE_HOME/bash/performance.log"
}

# Source bash components

for component in multiplexer functions aliases misc prompt; do
	if [ -r "$XDG_CONFIG_HOME/bash/$component.sh" ]; then
		timer=$(performance_timer_start)
		. "$XDG_CONFIG_HOME/bash/$component.sh"
		performance_timer_end "$timer" "$component.sh"
	fi
done

if [ -r "/usr/share/bash-completion/bash_completion" ]; then
	if [ -r "$XDG_CONFIG_HOME/bash/completions.sh" ]; then
		timer=$(performance_timer_start)
		. "$XDG_CONFIG_HOME/bash/completions.sh"
		performance_timer_end "$timer" "bash_completion"
	fi
fi
