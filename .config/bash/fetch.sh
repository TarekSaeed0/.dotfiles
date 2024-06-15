#!/bin/bash

if command -v neofetch &>/dev/null; then
	__fetch_id="$USER"
	if ! [ -f "${TMPDIR:-/tmp}/__fetch.$__fetch_id" ]; then
		touch "${TMPDIR:-/tmp}/__fetch.$__fetch_id"
		trap "command rm \"\${TMPDIR:-/tmp}/__fetch.\$__fetch_id\" &> /dev/null" EXIT
		neofetch
	fi
fi
