#!/bin/zsh

loadenv() {
	local file="${1:-.env}"
	if [[ ! -f "$file" ]]; then
		echo "No such file: $file"
		return 1
	fi

  local -a lines
  lines=( ${(f)"$(<"$file")"} )

  local line
  for line in "$lines[@]"; do
    if  [[ "$line" =~ '^\s*(#|$)' ]]; then
      continue
    fi

    local key="${line%%=*}"
    local value="${line#*=}"

    if [[ "$key" =~ '^[A-Za-z_][A-Za-z0-9_]*$' ]]; then
      export "$key=$value"
    fi
  done
}