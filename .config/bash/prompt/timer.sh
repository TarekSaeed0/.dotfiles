#!/bin/bash

export PS0='$(__prompt_timer_start "$__prompt_id")'

PROMPT_TIMER_FILE="${TMPDIR:-/tmp}/__prompt.$__prompt_id.timer"
PROMPT_TIMER_START_FILE="$PROMPT_TIMER_FILE.start"
PROMPT_TIMER_DURATION_FILE="$PROMPT_TIMER_FILE.duration"

__prompt_timer_start() {
	date +%s.%N >"$PROMPT_TIMER_START_FILE"
}
__prompt_timer_end() {
	if [ -f "$PROMPT_TIMER_START_FILE" ]; then
		awk \
			-v start="$(cat "$PROMPT_TIMER_START_FILE")" \
			-v end="$(date +%s.%N)" \
			'BEGIN { print end - start }' >"$PROMPT_TIMER_DURATION_FILE"
		command rm "$PROMPT_TIMER_START_FILE" &>/dev/null
	fi
}
__prompt_timer() {
	if [ -f "$PROMPT_TIMER_DURATION_FILE" ]; then
		local icon=""

		local time=""

		local duration
		duration="$(cat "$PROMPT_TIMER_DURATION_FILE")"

		local hours
		hours="$(awk -v duration="$duration" 'BEGIN { print int(duration / 3600) }')"
		if [ "$hours" != 0 ]; then
			time+="${hours}h "
		fi

		local minutes
		minutes="$(awk -v duration="$duration" 'BEGIN { print int(duration / 60 % 60) }')"
		if [ "$minutes" != 0 ]; then
			time+="${minutes}m "
		fi

		local seconds
		seconds="$(awk -v duration="$duration" 'BEGIN { printf("%.2f", duration % 60) }')"
		if [ "$seconds" != "0.00" ] || [ -z "$time" ]; then
			time+="${seconds}s "
		fi

		echo -ne "${time::-1}  \[\e[1D$icon\] "

		command rm "$PROMPT_TIMER_DURATION_FILE" &>/dev/null
	fi
}

__prompt_timer_start "$__prompt_id"
trap 'command rm "$PROMPT_TIMER_START_FILE" "$PROMPT_TIMER_DURATION_FILE" &>/dev/null' EXIT
