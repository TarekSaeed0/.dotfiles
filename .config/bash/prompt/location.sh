#!/bin/bash

__prompt_location() {
	local path="$PWD"
	local maximum_length="$(($(tput cols) / 4))"

	local icon=""
	if [ "$path" = "$HOME" ]; then
		icon=""
	elif command -v xdg-user-dir &>/dev/null; then
		case "$path" in
		"$(xdg-user-dir DESKTOP)") icon="󰍹" ;;
		"$(xdg-user-dir DOWNLOAD)") icon="󰇚" ;;
		"$(xdg-user-dir TEMPLATES)") icon="󰘓" ;;
		"$(xdg-user-dir PUBLICSHARE)") icon="" ;;
		"$(xdg-user-dir DOCUMENTS)") icon="" ;;
		"$(xdg-user-dir MUSIC)") icon="" ;;
		"$(xdg-user-dir PICTURES)") icon="" ;;
		"$(xdg-user-dir VIDEOS)") icon="󰿎" ;;
		esac
	fi

	local separator="/"
	local ellipsis="…"

	local parent=""
	local name="$path"
	if [[ $path =~ ^(.*$separator)([^$separator]+)$ ]]; then
		parent="${BASH_REMATCH[1]}"
		name="${BASH_REMATCH[2]}"
	fi
	if ((${#path} > maximum_length)); then
		parent="${parent:$((${#parent} + ${#ellipsis} + ${#separator} + ${#name} - maximum_length))}"
		if [[ $parent =~ [^$separator]*$separator?(.*)$ ]]; then
			parent="${BASH_REMATCH[1]}"
		fi
		parent=" \001\e[1D$ellipsis\002$separator$parent"
	fi

	echo -e " \001\e[1D$icon\002 $parent\001\e[0;1;48;2;24;24;37m\002$name"
}