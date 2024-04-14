#!/bin/bash

cd() {
	if [[ "$1" == "--" ]]; then
		dirs -v
		return 0
	fi

	local destination="$1"
	if [[ -z "$destination" ]]; then
		destination="$HOME"
	fi

	if [[ "${destination:0:1}" == "-" ]]; then
		local index="${destination:1}"
		if [[ -z "$index" ]]; then
			index=1
		fi

		if ! destination="$(dirs +"$index" 2>/dev/null)"; then
			return 1
		fi
	fi

	if [[ "${destination:0:1}" == "~" ]]; then
		destination="$HOME${destination:1}"
	fi

	local index=0
	while :; do
		local directory
		if ! directory="$(dirs +$index 2>/dev/null)"; then
			break
		fi
		if [[ "${directory:0:1}" == "~" ]]; then
			directory="$HOME${directory:1}"
		fi

		if [[ "$directory" -ef "$destination" ]]; then
			if ! popd -n +$index &>/dev/null; then
				break
			fi
		else
			((index++))
		fi
	done

	if ! pushd "$destination" &>/dev/null; then
		return 1
	fi

	return 0
}
