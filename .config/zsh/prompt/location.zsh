#!/bin/zsh

typeset -A __prompt_location_icons=(
	[default]=""
	[$HOME]=""
)

if (( $+commands[xdg-user-dir] )); then
	local desktop="$(xdg-user-dir DESKTOP)"
	local download="$(xdg-user-dir DOWNLOAD)"
	local templates="$(xdg-user-dir TEMPLATES)"
	local public="$(xdg-user-dir PUBLICSHARE)"
	local documents="$(xdg-user-dir DOCUMENTS)"
	local music="$(xdg-user-dir MUSIC)"
	local pictures="$(xdg-user-dir PICTURES)"
	local videos="$(xdg-user-dir VIDEOS)"
	
	__prompt_location_icons+=(
		[$desktop]="󰍹"
		[$download]="󰇚"
		[$templates]="󰘓"
		[$public]=""
		[$documents]=""
		[$music]=""
		[$pictures]=""
		[$videos]="󰿎"
	)
fi

__prompt_location() {
	local maximum_length=$(( COLUMNS / 4 ))
	local path="$PWD"
	
	local icon="${__prompt_location_icons[$path]:-${__prompt_location_icons[default]}}"
	
	local separator="/"
	local ellipsis="…"

	path="${path/#$HOME/\~}"
	local parent=""
	local name="${path##*$separator}"
	if [[ -n "$name" && "$path" == *"$separator"* ]]; then
		parent="${path%$separator*}$separator"
		
		if (( ${#path} > maximum_length )); then
			parent="${parent: -(( maximum_length - ${#ellipsis} - ${#separator} - ${#name} ))}"
			parent="$ellipsis$separator${parent#*$separator}"
		fi
	else
		name="$path"
	fi
	
	print " $icon $parent%f%B$name%b%F{#6c7086} "
}
