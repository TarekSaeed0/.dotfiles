# return if not interactive

case $- in
*i*) ;;
*) return ;;
esac

# start tmux session if not already in one

if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
	if tmux &>/dev/null; then
		exit
	fi
fi

# prompt

PS0="\$(__prompt_timer_start \$ROOTPID)"

PROMPT_COMMAND="__prompt_command"
__prompt_command() {
	local exit="$?"
	local timer
	timer="$(__prompt_timer_end)"

	PS1L=""
	PS1L+="\[\e[1;38;2;203;166;247m\] \[\e[1D\]"
	PS1L+="\[\e[38;2;24;24;37;48;2;203;166;247m\]  \[\e[1D\] \[\e[1m\]\u "
	PS1L+="\[\e[38;2;203;166;247;48;2;24;24;37m\]  \[\e[2D\]"
	PS1L+="\[\e[0;38;2;108;112;134;48;2;24;24;37m\] "

	if git branch --no-color &>/dev/null; then
		PS1L+=" \[\e[1D\] $(git branch --no-color | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/') "
	fi

	if [ -f "$XDG_CONFIG_HOME/user-dirs.dirs" ]; then
		. "$XDG_CONFIG_HOME/user-dirs.dirs"
	fi
	PS1L+=" \[\e[1D"
	if [ "$PWD" = "$HOME" ]; then
		PS1L+=""
	elif command -v xdg-user-dir &>/dev/null; then
		case "$PWD" in
		"$(xdg-user-dir DESKTOP)") PS1L+="󰍹" ;;
		"$(xdg-user-dir DOWNLOAD)") PS1L+="󰇚" ;;
		"$(xdg-user-dir TEMPLATES)") PS1L+="󰘓" ;;
		"$(xdg-user-dir PUBLICSHARE)") PS1L+="" ;;
		"$(xdg-user-dir DOCUMENTS)") PS1L+="" ;;
		"$(xdg-user-dir MUSIC)") PS1L+="" ;;
		"$(xdg-user-dir PICTURES)") PS1L+="" ;;
		"$(xdg-user-dir VIDEOS)") PS1L+="󰿎" ;;
		*) PS1L+="" ;;
		esac
	else
		PS1L+=""
	fi
	PS1L+="\] \$(__prompt_cwd \"\w\") "

	PS1L+="\[\e[0;1;38;2;24;24;37m\] \[\e[1D\]"
	PS1L+="\[\e[0m\]"
	PS1L+=" "

	PS1R=""

	if [ -n "$timer" ]; then
		if [ "$exit" != 0 ]; then
			PS1R+="\[\e[1;31m\]$exit  \[\e[1D\] "
		fi

		PS1R+="\[\e[0;38;2;108;112;134;48;2;24;24;37m\]"

		local hours
		hours="$(awk -v timer="$timer" "BEGIN { print int(timer / 3600) }")"
		if [ "$hours" != 0 ]; then
			PS1R+="${hours}h "
		fi

		local minutes
		minutes="$(awk -v timer="$timer" "BEGIN { print int(timer / 60 % 60) }")"
		if [ "$minutes" != 0 ]; then
			PS1R+="${minutes}m "
		fi

		local seconds
		seconds="$(awk -v timer="$timer" "BEGIN { print timer % 60 }")"
		PS1R+="${seconds}s "

		PS1R+=" \[\e[1D\] "

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

	PS1="\[\e[$((COLUMNS - ${#PS1R_stripped} + 1))G$PS1R\e[0G\]$PS1L"
}

# prompt current working directory

__prompt_cwd() {
	local path="$1"
	local maximum_length="$(($(tput cols) / 4))"

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

	echo -e "$parent\001\e[0;1;48;2;24;24;37m\002$name"
}

# prompt timer

__prompt_timer_id="$USER.$BASHPID"
__prompt_timer_start() {
	date +%s.%N >"${TMPDIR:-/tmp}/$__prompt_timer_id.__prompt_timer"
}
__prompt_timer_end() {
	if [ -f "${TMPDIR:-/tmp}/$__prompt_timer_id.__prompt_timer" ]; then
		awk \
			-v start="$(cat "${TMPDIR:-/tmp}/$__prompt_timer_id.__prompt_timer")" \
			-v end="$(date +%s.%N)" \
			"BEGIN { printf(\"%.2f\", end - start) }"
		command rm "${TMPDIR:-/tmp}/$__prompt_timer_id.__prompt_timer" &>/dev/null
	fi
}
__prompt_timer_start
trap "command rm \"\${TMPDIR:-/tmp}/\$__prompt_timer_id.__prompt_timer\" &> /dev/null" EXIT

# fetch only once

if command -v neofetch &>/dev/null; then
	__fetch_id="$USER"
	if ! [ -f "${TMPDIR:-/tmp}/$__fetch_id.fetch" ]; then
		touch "${TMPDIR:-/tmp}/$__fetch_id.fetch"
		trap "command rm \"\${TMPDIR:-/tmp}/\$__fetch_id.fetch\" &> /dev/null" EXIT
		neofetch
	fi
fi

# aliases

# ask for confirmation

alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"

# set directory colors if possible and enable colors for some commands

if command -v dircolors &>/dev/null; then
	if [ -r "$HOME/.dircolors" ]; then
		eval "$(dircolors -b "$HOME/.dircolors")"
	else
		eval "$(dircolors -b)"
	fi

	eval "$(dircolors -b <(echo "DIR 1;38;2;148;226;213"))"

	if command -v exa &>/dev/null; then
		function ls() {
			if [ -t 1 ]; then
				exa -lgM --git --color=always --icons=always "$@" | sed "s///g" | sed "s///g"
			else
				command ls "$@"
			fi
		}
	else
		function ls() { command ls -lsh --color "$@" | tail -n +2; }
	fi
	alias dir="dir --color=auto"
	alias vdir="vdir --color=auto"

	alias grep="grep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias egrep="egrep --color=auto"
else
	if command -v exa &>/dev/null; then
		function ls() {
			if [ -t 1 ]; then
				exa -lgM --git --color=never --icons=always "$@" | sed "s///g"
			else
				command ls "$@"
			fi
		}
	else
		function ls() {
			if [ -t 1 ]; then
				command ls -lsh "$@" | tail -n +2
			else
				command ls "$@"
			fi
		}
	fi
fi

retry() {
	while :; do
		if "$@" || [ "$?" = 130 ]; then
			break
		fi
	done
}

# source command not found if installed

if [ -r "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
	. "/usr/share/doc/pkgfile/command-not-found.bash"
fi

for script in cd.sh dotfiles.sh; do
	. "$XDG_CONFIG_HOME/bash/functions/$script"
done
