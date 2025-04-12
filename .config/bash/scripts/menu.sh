#!/bin/bash

# inspired by https://web.archive.org/web/20180130222805/http://pro-toolz.net/data/programming/bash/Bash_fancy_menu.html

option_color="203;166;247"

# each option must be in the format: icon name command
options=(
	"󰣇" "Arch Terminal" "proot-distro login archlinux --user tarek --shared-tmp"
	"" "Arch Desktop" "bash /data/data/com.termux/files/home/bin/termux-desktop"
	"" "Arch Desktop VNC" "bash /data/data/com.termux/files/home/bin/termux-desktop-vnc"
	"" "Terminal" "bash"
)

# add the exit option
options+=("󰩈" "Exit" "exit 0")

# find the maximum option width
options_width=0
for ((i = 1; i < ${#options[@]}; i += 3)); do
	option="${options[i]}"
	if [ "${#option}" -gt "${options_width}" ]; then
		options_width="${#option}"
	fi
done

# pad each option to the maximum option width
for ((i = 1; i < ${#options[@]}; i += 3)); do
	options[i]="$(printf "%-${options_width}s" "${options[i]}")"
done

#######################################
# Display an option.
# Globals:
# 	option_color
# 	options
# 	header
# Arguments:
# 	Index of the option to display.
#######################################
display_option() {
	# center the option
	echo -en "\e[$(((LINES - (${#header[@]} + 3 + ${#options[@]} / 3 + 2)) / 2 + ${#header[@]} + 3 + ${1} + 1));$(((COLUMNS - (options_width + 9)) / 2 - 1))H"

	local index="${1}"
	if [ "${index}" = "${current}" ]; then
		echo -en "\e[1;38;2;${option_color}m \e[38;2;24;24;37;48;2;${option_color}m ${options[3 * ${1}]} \e[38;2;${option_color};48;2;24;24;37m\e[0;1;48;2;24;24;37m ${options[3 * ${1} + 1]} \e[0;1;38;2;24;24;37m\e[0m"
	else
		echo -en "\e[1;38;2;${option_color}m  \e[38;2;24;24;37;48;2;${option_color}m ${options[3 * ${1}]} \e[38;2;${option_color};48;2;24;24;37m\e[0;38;2;108;112;134;48;2;24;24;37m ${options[3 * ${1} + 1]} \e[0;1;38;2;24;24;37m\e[0m"
	fi
}

header_color="148;226;213"

headers=(
	'''
                ██  ██  ██  ██████
                ██  ██  ██      ██
                ██  ██  ██  ██████
                ██  ██  ██  ██  ██
        ██████  ██  ██  ██  ██████  ██████
        ██  ██  ██  ██  ██  ██      ██  ██
        ██████████████  ██  ██████  ██████
                            ██      ██
██████████  ██  ██  ██  ██  ██████  ██████████████
██  ██  ██  ██  ██  ██  ██  ██      ██
██  ██████████████████████  ██████  ██████████████
                            ██
██████████████  ██████  ██  ██████  ██████████████
                    ██
██████████████  ██████  ██████████████████████  ██
            ██      ██  ██  ██  ██  ██  ██  ██  ██
██████████████  ██████  ██  ██  ██  ██  ██████████
            ██      ██
        ██████  ██████  ██  ██████████████
        ██  ██      ██  ██  ██  ██  ██  ██
        ██████  ██████  ██  ██  ██  ██████
                ██  ██  ██  ██  ██
                ██████  ██  ██  ██
                ██      ██  ██  ██
                ██████  ██  ██  ██

'''
	'''
        ▄ ▄ ▄ ▄▄▄
        █ █ █ ▄▄█
    ▄▄▄ █ █ █ █▄█ ▄▄▄
    █▄█▄█▄█ █ █▄▄ █▄█
▄▄▄▄▄ ▄ ▄ ▄ ▄ █▄▄ █▄▄▄▄▄▄
█ █▄█▄█▄█▄█▄█ █▄▄ █▄▄▄▄▄▄
▄▄▄▄▄▄▄ ▄▄▄ ▄ █▄▄ ▄▄▄▄▄▄▄
▄▄▄▄▄▄▄ ▄▄█ ▄▄▄▄▄▄▄▄▄▄▄ ▄
▄▄▄▄▄▄█ ▄▄█ █ █ █ █ █▄█▄█
    ▄▄█ ▄▄█ ▄ ▄▄▄▄▄▄▄
    █▄█ ▄▄█ █ █ █ █▄█
        █▄█ █ █ █
        █▄▄ █ █ █
'''
	'''
██████  ██  ██  ██  ██  ██  ██
██  ██  ██  ██  ██  ██  ██  ██
██████████████████████  ██  ██
██                      ██  ██
██  ██  ██  ██  ██  ██  ██  ██
    ██  ██  ██  ██      ██  ██
██████  ██  ██  ██  ██  ██  ██
██  ██  ██  ██  ██  ██  ██  ██
██████████████  ██  ██  ██  ██
                    ██  ██  ██
██  ██    ████████  ██      ██
    ██          ██  ██  ██  ██
██  ██████████████  ██  ██  ██
██  ██  ██  ██      ██  ██  ██
██████  ██████  ██████  ██  ██
                ██      ██  ██
██████████████████  ██  ██  ██
                    ██  ██  ██
██████████  ██████  ██  ██  ██
██  ██  ██      ██  ██  ██  ██
██████  ██████████  ██████  ██
██                  ██      ██
██  ██  ██  ██████████  ██████
'''
	'''
▄▄▄ ▄ ▄ ▄ ▄ ▄ ▄
█▄█▄█▄█▄█▄█ █ █
█ ▄ ▄ ▄ ▄ ▄ █ █
▄▄█ █ █ █ ▄ █ █
█▄█▄█▄█ █ █ █ █
▄ ▄  ▄▄▄▄ █ ▀ █
▄ █▄▄▄▄▄█ █ █ █
█▄█ █▄█ ▄▄█ █ █
▄▄▄▄▄▄▄▄█ ▄ █ █
▄▄▄▄▄ ▄▄▄ █ █ █
█▄█ █▄▄▄█ █▄█ █
█ ▄ ▄ ▄▄▄▄█ ▄▄█
'''
)

header_index="$((RANDOM % (${#headers[@]} / 2) * 2))"

message="Termux - a terminal emulator for Android"

footer=" Termux v${TERMUX_VERSION}"

#######################################
# Display the menu.
# Globals:
#		header_color
# 	headers
# 	header_index
#   message
#   footer
#   options
#   header
# Arguments:
# 	None
#######################################
display_menu() {
	clear

	IFS=$'\n' read -rd '' -a header <<<"${headers[header_index]}"

	# find the header's width
	header_width=0
	for ((i = 0; i < ${#header[@]}; i++)); do
		local line="${header[i]}"
		if [ "${#line}" -gt "${header_width}" ]; then
			header_width="${#line}"
		fi
	done

	# use small version of header if the big version doesn't fit
	if [ "$((${#header[@]} + 3 + ${#options[@]} / 3 + 2))" -gt "${LINES}" ] || [ "${header_width}" -gt "${COLUMNS}" ]; then
		IFS=$'\n' read -rd '' -a header <<<"${headers[header_index + 1]}"

		# find the small header's width
		header_width=0
		for ((i = 0; i < ${#header[@]}; i++)); do
			local line="${header[i]}"
			if [ "${#line}" -gt "${header_width}" ]; then
				header_width="${#line}"
			fi
		done
	fi

	# display the header
	echo -e "\e[$(((LINES - (${#header[@]} + 3 + ${#options[@]} / 3 + 2)) / 2));0H\e[1;38;2;${header_color}m"
	for line in "${header[@]}"; do
		echo -e "\e[$(((COLUMNS - header_width) / 2 + 1))G${line}"
	done

	echo -en "\e[$(((LINES - (${#header[@]} + 3 + ${#options[@]} / 3 + 2)) / 2 + ${#header[@]} + 2));$(((COLUMNS - ${#message} - 4) / 2 + 1))H\e[1;38;2;24;24;37m\e[0;38;2;108;112;134;48;2;24;24;37m ${message} \e[0;1;38;2;24;24;37m\e[0m"

	# display the options
	for ((i = 0; i < ${#options[@]} / 3; i++)); do
		display_option "${i}"
	done

	# display footer
	echo -en "\e[$(((LINES - (${#header[@]} + 3 + ${#options[@]} / 3 + 2)) / 2 + ${#header[@]} + 3 + ${#options[@]} / 3 + 2));$(((COLUMNS - ${#footer} - 4) / 2 + 1))H\e[1;38;2;24;24;37m\e[0;38;2;108;112;134;48;2;24;24;37m ${footer} \e[0;1;38;2;24;24;37m\e[0m"
}

current=0

# save screen contents
echo -en "\e[?1049h"
# show cursor and restore screen contents on exit
trap "echo -en \"\e[?25h\e[?1049l\"; exit 0" EXIT INT

# display menu on terminal size change
trap "display_menu" WINCH

# hide the cursor
echo -en "\e[?25l"

display_menu

# main loop
while :; do
	# get input
	# https://sourceforge.net/p/playshell/code/ci/master/tree/source/keys.sh#l44
	if read -rsn1 input && [ "${input}" = $'\e' ]; then
		if read -rsn1 -t 0.01; then
			input+="${REPLY}"
			case "${REPLY}" in
			"[")
				while read -rsn1 -t 0.01 && [[ "${REPLY}" != [[:upper:]~] ]]; do
					input+="${REPLY}"
				done
				input+="${REPLY}"
				;;
			"O")
				if read -rsn1 -t 0.01; then
					input+="${REPLY}"
				fi
				;;
			esac
		fi
	fi

	# handle input
	# enter
	if [ "${input}" = "" ]; then
		clear

		# unhide cursor
		echo -en "\e[?25h"

		eval "${options[3 * ${current} + 2]}"

		# rehide cursor
		echo -en "\e[?25l"

		display_menu
	# up arrow
	elif [ "${input}" = $'\e[A' ]; then
		previous="${current}"
		((current--))
		if [ "${current}" -lt 0 ]; then
			current="$((${#options[@]} / 3 - 1))"
		fi
		display_option "${previous}"
		display_option "${current}"
	# down arrow
	elif [ "${input}" = $'\e[B' ]; then
		previous="${current}"
		((current++))
		if [ "${current}" -eq "$((${#options[@]} / 3))" ]; then
			current=0
		fi
		display_option "${previous}"
		display_option "${current}"
	fi
done
