#!/bin/bash

if command -v neofetch &>/dev/null; then
	__fetch_id="$USER"
	if ! [ -f "${TMPDIR:-/tmp}/$__fetch_id.fetch" ]; then
		touch "${TMPDIR:-/tmp}/$__fetch_id.fetch"
		trap "command rm \"\${TMPDIR:-/tmp}/__fetch.\$__fetch_id\" &> /dev/null" EXIT
		neofetch
	fi
fi
