#!/bin/bash

#export PS0="\$(__prompt_timer_start $1)"
#export PS1="\$(__prompt_timer_end $1)"

__prompt_timer_start() {
	date +%s.%N >"${TMPDIR:-/tmp}/__prompt.$1.timer_start"
}
__prompt_timer_end() {
	if [ -f "${TMPDIR:-/tmp}/__prompt.$1.timer_start" ]; then
		awk \
			-v start="$(cat "${TMPDIR:-/tmp}/__prompt.$1.timer_start")" \
			-v end="$(date +%s.%N)" \
			'BEGIN { print end - start }' >"${TMPDIR:-/tmp}/__prompt.$1.timer"
		command rm "${TMPDIR:-/tmp}/__prompt.$1.timer_start" &>/dev/null
	fi
}
__prompt_timer() {
	if [ -f "${TMPDIR:-/tmp}/__prompt.$1.timer" ]; then
		local icon=""

		local time=""

		local timer
		timer="$(cat "${TMPDIR:-/tmp}/__prompt.$1.timer")"

		local hours
		hours="$(awk -v timer="$timer" 'BEGIN { print int(timer / 3600) }')"
		if [ "$hours" != 0 ]; then
			time+="${hours}h "
		fi

		local minutes
		minutes="$(awk -v timer="$timer" 'BEGIN { print int(timer / 60 % 60) }')"
		if [ "$minutes" != 0 ]; then
			time+="${minutes}m "
		fi

		local seconds
		seconds="$(awk -v timer="$timer" 'BEGIN { printf("%.2f", timer % 60) }')"
		if [ "$seconds" != "0.00" ] || [ -z "$time" ]; then
			time+="${seconds}s "
		fi

		echo -e "${time::-1}  \[\e[1D$icon\] "

		command rm "${TMPDIR:-/tmp}/__prompt.$1.timer" &>/dev/null
	fi
}

__prompt_timer_start "$1"
trap 'command rm "${TMPDIR:-/tmp}/__prompt.'"$1"'.timer_start" "${TMPDIR:-/tmp}/__prompt.'"$1"'.timer" &>/dev/null' EXIT
