#!/bin/bash

diff() {
	if command -v delta &>/dev/null; then
		delta "$@"
	else
		diff "$@"
	fi
}
