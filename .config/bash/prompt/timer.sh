#!/bin/bash

PS0="\$(__prompt_timer_start $1)"
__prompt_timer_start() {
	date +%s.%N >"${TMPDIR:-/tmp}/__prompt.$1.timer"
}
__prompt_timer_end() {
	if [ -f "${TMPDIR:-/tmp}/__prompt.$1.timer" ]; then
		awk \
			-v start="$(cat "${TMPDIR:-/tmp}/__prompt.$1.timer")" \
			-v end="$(date +%s.%N)" \
			'BEGIN { printf("%.2f", end - start) }'
		command rm "${TMPDIR:-/tmp}/__prompt.$1.timer" &>/dev/null
	fi
}
__prompt_timer_start "$1"
trap 'command rm "${TMPDIR:-/tmp}/__prompt.'"$1"'.timer" &> /dev/null' EXIT
