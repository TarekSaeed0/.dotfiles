#!/bin/bash

export PS0="\$(__prompt_timer_start $1)"
export PS1="\$(__prompt_timer_end $1)"

__prompt_timer_start() {
	date +%s.%N >"${TMPDIR:-/tmp}/__prompt.$1.timer_start"
}
__prompt_timer_end() {
	if [ -f "${TMPDIR:-/tmp}/__prompt.$1.timer_start" ]; then
		awk \
			-v start="$(cat "${TMPDIR:-/tmp}/__prompt.$1.timer_start")" \
			-v end="$(date +%s.%N)" \
			'BEGIN { printf("%.2f", end - start) }' >"${TMPDIR:-/tmp}/__prompt.$1.timer"
		command rm "${TMPDIR:-/tmp}/__prompt.$1.timer_start" &>/dev/null
	fi
}
__prompt_timer() {
	[ -f "${TMPDIR:-/tmp}/__prompt.$1.timer" ] && cat "${TMPDIR:-/tmp}/__prompt.$1.timer"
}

__prompt_timer_start "$1"
trap 'command rm "${TMPDIR:-/tmp}/__prompt.'"$1"'.timer_start" &> /dev/null' EXIT
