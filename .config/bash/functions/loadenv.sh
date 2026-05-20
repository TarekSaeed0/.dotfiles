#!/bin/bash

loadenv() {
	local file="${1:-.env}"
	[[ -f "$file" ]] || {
		echo "No such file: $file"
		return 1
	}

	while IFS='=' read -r key value; do
		[[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || continue
		[[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
		export "$key=${value%$'\r'}"
	done <"$file"
}
