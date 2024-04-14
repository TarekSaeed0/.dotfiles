#!/bin/bash

cd() {
	if [ "$1" = "--" ]; then
		dirs -v
		return 0
	fi

	local destination="$1"
	[ -z "$destination" ] && destination="$HOME"

	if [ "${destination:0:1}" = "-" ]; then
		local index="${destination:1}"
		[ -z "$index" ] && index=1

		destination="$(dirs -l +"$index" 2>/dev/null)" || return
	elif [ "${destination:0:1}" = "~" ]; then
		destination="$HOME${destination:1}"
	fi

	pushd "$destination" &>/dev/null || return

	destination="$PWD"

	local index=1
	while :; do
		local directory
		directory="$(dirs -l +$index 2>/dev/null)" || break

		if [ "$directory" -ef "$destination" ]; then
			popd -n +$index &>/dev/null || break
		else
			((index++))
		fi
	done

	ls
}
