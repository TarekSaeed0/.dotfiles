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

function __prompt_location() {
	local maximum_length=$(( COLUMNS / 4 ))

	local location="$PWD"
	
	local icon="${__prompt_location_icons[$location]:-${__prompt_location_icons[default]}}"
	
	local separator="/"
	local ellipsis="…"

	location="${location/#$HOME/~}"
	local parent=""
	local name="${location##*$separator}"
	if [[ -n "$name" && "$location" == *"$separator"* ]]; then
		parent="${location%$separator*}$separator"

		if (( ${#location} > maximum_length )); then
			parent="${parent[-(( maximum_length - ${#ellipsis} - ${#separator} - ${#name} )),-1]}"
			parent="$ellipsis$separator${parent#*$separator}"
		fi
	else
		name="$location"
	fi
	
	print " $icon $parent%f%B$name%b%F{#6c7086} "
}
