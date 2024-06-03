#!/bin/bash

export PS0='$(__prompt_timer_start "$__prompt_id")'

__prompt_timer_start() {
	date +%s.%N >"${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer_start"
}
__prompt_timer_end() {
	if [ -f "${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer_start" ]; then
		awk \
			-v start="$(cat "${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer_start")" \
			-v end="$(date +%s.%N)" \
			'BEGIN { print end - start }' >"${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer"
		command rm "${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer_start" &>/dev/null
	fi
}
__prompt_timer() {
	if [ -f "${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer" ]; then
		local icon=""

		local time=""

		local timer
		timer="$(cat "${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer")"

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

		echo -ne "${time::-1}  \[\e[1D$icon\] "

		command rm "${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer" &>/dev/null
	fi
}

__prompt_timer_start "$__prompt_id"
trap 'command rm "${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer_start" "${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer" &>/dev/null' EXIT
