#!/bin/bash

cat() {
	if command -v bat &>/dev/null; then
		bat -P "$@"
	else
		cat "$@"
	fi
}
