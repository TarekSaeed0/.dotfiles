#!/bin/bash

# retry command until it succeeds

retry() {
	while :; do
		if "$@" || [ "$?" = 130 ]; then
			break
		fi
	done
}
