#!/bin/bash

for completion in dotfiles create_project; do
	if [ -r "$XDG_CONFIG_HOME/bash/completions/${completion}.sh" ]; then
		timer=$(performance_timer_start)
		. "$XDG_CONFIG_HOME/bash/completions/${completion}.sh"
		performance_timer_end "$timer" "	$completion completion"
	fi
done

# if command -v flutter &>/dev/null; then
# 	timer=$(performance_timer_start)
# 	eval "$(flutter bash-completion)"
# 	performance_timer_end "$timer" "	flutter completion"
# fi
#
# if command -v ng &>/dev/null; then
# 	timer=$(performance_timer_start)
# 	source <(ng completion script)
# 	performance_timer_end "$timer" "	ng completion"
# fi
