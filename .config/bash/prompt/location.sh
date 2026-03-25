#!/bin/bash

declare -A __PROMPT_LOCATION_ICONS=(
	["default"]=""
	["$HOME"]=""
)

if command -v xdg-user-dir &>/dev/null; then
	__PROMPT_LOCATION_ICONS["$(xdg-user-dir DESKTOP)"]="󰍹"
	__PROMPT_LOCATION_ICONS["$(xdg-user-dir DOWNLOAD)"]="󰇚"
	__PROMPT_LOCATION_ICONS["$(xdg-user-dir TEMPLATES)"]="󰘓"
	__PROMPT_LOCATION_ICONS["$(xdg-user-dir PUBLICSHARE)"]=""
	__PROMPT_LOCATION_ICONS["$(xdg-user-dir DOCUMENTS)"]=""
	__PROMPT_LOCATION_ICONS["$(xdg-user-dir MUSIC)"]=""
	__PROMPT_LOCATION_ICONS["$(xdg-user-dir PICTURES)"]=""
	__PROMPT_LOCATION_ICONS["$(xdg-user-dir VIDEOS)"]="󰿎"
fi

__prompt_location() {
	local maximum_length="$((COLUMNS / 4))"

	local path="$PWD"

	local icon="${__PROMPT_LOCATION_ICONS[$path]:-${__PROMPT_LOCATION_ICONS["default"]}}"

	local separator="/"
	local ellipsis="…"

	path="${path/#$HOME/\~}"
	local parent=""
	local name="${path##*/}"
	if ! [[ -z "$name" ]] && [[ "$path" == *"$separator"* ]]; then
		parent="${path%"$separator"*}/"

		if ((${#path} > maximum_length)); then
			local ellipsis="…"
			parent="${parent: -((maximum_length - ${#name}))}"
			parent="$ellipsis/${parent#*"$separator"}"
		fi
	else
		name="$path"
	fi

	echo -ne " \[\e[1D$icon\] $parent\[\e[0;1;48;2;24;24;37m\]$name "
}
