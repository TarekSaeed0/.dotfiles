#!/bin/bash

cd() {
	if [[ "$1" == "--" ]]; then
		dirs -v
		return 0
	fi

	local destination="$1"

	if [[ "${destination:0:1}" == '-' ]]; then
		local index="${destination:1}"
		if [[ -z "$index" ]]; then
			index=1
		fi

		destination="$(dirs +$index)"
		if [[ -z "$destination" ]]; then
			return 1
		fi
	fi

	local index=0
	while dirs +$index &>/dev/null; do
		if [[ $(dirs +$index) -ef $destination ]]; then
			popd -n +$index &>/dev/null
		else
			((index++))
		fi
	done

	if ! pushd "$destination" &>/dev/null; then
		return 1
	fi

	return 0
}
