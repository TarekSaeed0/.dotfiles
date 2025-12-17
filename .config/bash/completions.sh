#!/bin/bash

for completion in dotfiles create_project; do
	if [ -r "$XDG_CONFIG_HOME/bash/completions/${completion}.sh" ]; then
		start_time=$(date +%s.%N)
		. "$XDG_CONFIG_HOME/bash/completions/${completion}.sh"
		end_time=$(date +%s.%N)
		elapsed_time=$(awk \
			-v start="$start_time" \
			-v end="$end_time" \
			'BEGIN { print end - start }')
		echo "$completion completion took $elapsed_time seconds" >>"$HOME/bash.log"
	fi
done

if command -v flutter &>/dev/null; then
	start_time=$(date +%s.%N)
	eval "$(flutter bash-completion)"
	end_time=$(date +%s.%N)
	elapsed_time=$(awk \
		-v start="$start_time" \
		-v end="$end_time" \
		'BEGIN { print end - start }')
	echo "flutter completion took $elapsed_time seconds" >>"$HOME/bash.log"
fi

# if command -v ng &>/dev/null; then
# 	start_time=$(date +%s.%N)
# 	source <(ng completion script)
# 	end_time=$(date +%s.%N)
# 	elapsed_time=$(awk \
# 		-v start="$start_time" \
# 		-v end="$end_time" \
# 		'BEGIN { print end - start }')
# 	echo "ng completion took $elapsed_time seconds" >>"$HOME/bash.log"
# fi
