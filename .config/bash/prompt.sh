#!/bin/bash

export __prompt_id="$USER.$BASHPID"

for component in git location timer; do
	if [ -r "$XDG_CONFIG_HOME/bash/prompt/${component}.sh" ]; then
		. "$XDG_CONFIG_HOME/bash/prompt/${component}.sh"
	fi
done

__prompt_title() {
	local path="${PWD/#$HOME/\~}"
	local maximum_length=16

	local separator="/"
	local ellipsis="…"

	if [[ $path =~ ^(.*$separator)([^$separator]+)$ ]]; then
		parent="${BASH_REMATCH[1]}"
		name="${BASH_REMATCH[2]}"
	else
		local parent=""
		local name="$path"
	fi
	if ((${#path} > maximum_length)); then
		parent="${parent:$((${#parent} + ${#ellipsis} + ${#separator} + ${#name} - maximum_length))}"
		if [[ $parent =~ [^$separator]*$separator?(.*)$ ]]; then
			parent="${BASH_REMATCH[1]}"
		fi
		parent="$ellipsis$separator$parent"
	fi

	local location="$parent$name"

	echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:$location\007"
}

__prompt_command() {
	local exit="$?"

	__prompt_title

	__prompt_timer_end

	PS1L=""
	PS1L+="\[\e[1;38;2;203;166;247m\] \[\e[1D\]"
	PS1L+="\[\e[38;2;24;24;37;48;2;203;166;247m\]  \[\e[1D\] \[\e[1m\]\u "
	PS1L+="\[\e[38;2;203;166;247;48;2;24;24;37m\]  \[\e[2D\]"
	PS1L+="\[\e[0;38;2;108;112;134;48;2;24;24;37m\] "

	PS1L+="$(__prompt_git)"

	PS1L+="$(__prompt_location)"

	PS1L+="\[\e[0;1;38;2;24;24;37m\] \[\e[1D\]"
	PS1L+="\[\e[0m\]"
	PS1L+=" "

	PS1R=""

	local timer
	timer="$(__prompt_timer)"
	if [ -n "$timer" ]; then
		if [ "$exit" != 0 ]; then
			PS1R+="\[\e[1;31m\]$exit  \[\e[1D\] "
		fi

		PS1R+="\[\e[0;38;2;108;112;134;48;2;24;24;37m\]"

		PS1R+="$timer"

		PS1R_="$PS1R"
		PS1R=""

		PS1R+="\[\e[1;38;2;24;24;37m\] \[\e[1D\]"
		PS1R+="\[\e[48;2;24;24;37m\] "

		PS1R+="$PS1R_"

		PS1R+="\[\e[0;1;38;2;24;24;37m\] \[\e[1D\]"
		PS1R+="\[\e[0m\]"
	fi

	PS1R_stripped="${PS1R//\\\[*([^\]])\\\]/}"
	PS1R="${PS1R//@(\\\[|\\\])/}"

	PS1="$PS1L\[$(tput sc)\e[0G\e[$((COLUMNS - ${#PS1R_stripped} + 1))G$PS1R$(tput rc)\]"
}
PROMPT_COMMAND="__prompt_command"
