#!/bin/zsh

# retry command until it succeeds

retry() {
	while :; do
		"$@"
		local status=$?
		if [[ $status -eq 0 || $status -eq 130 ]]; then
			break
		fi
	done
}