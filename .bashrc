# return if not interactive

case $- in
    *i*) ;;
    *) return;;
esac

# start tmux session if not already in one

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
	exec tmux &> /dev/null
fi

# prompt

PS0="\$(__prompt_timer_start \$ROOTPID)"

PROMPT_COMMAND="__prompt_command"
__prompt_command() {
	local exit="$?"
	local timer
	timer="$(__prompt_timer_end)"

	PS1L=""
	PS1L+="\[\e[1;38;2;203;166;247m\]"
	PS1L+=" \[\e[1D\]"

	PS1L+="\[\e[38;2;24;24;37;48;2;203;166;247m\]"
	PS1L+="  \[\e[1D\] "
	PS1L+="\[\e[1m\]"
	PS1L+="\u "

	PS1L+="\[\e[38;2;203;166;247;48;2;24;24;37m\]"
	PS1L+="  \[\e[2D\]"
	PS1L+="\[\e[0;38;2;108;112;134;48;2;24;24;37m\]"

	PS1L+="  \[\e[1D"
	if [ -f "$XDG_CONFIG_HOME/user-dirs.dirs" ]; then
		. "$XDG_CONFIG_HOME/user-dirs.dirs"
	fi
	case "$PWD" in
		"$HOME") PS1L+="";;
		"$XDG_DESKTOP_DIR") PS1L+="󰍹";;
		"$XDG_DOWNLOAD_DIR") PS1L+="󰇚";;
		"$XDG_TEMPLATES_DIR") PS1L+="";;
		"$XDG_PUBLICSHARE_DIR") PS1L+="";;
		"$XDG_DOCUMENTS_DIR") PS1L+="󰈙";;
		"$XDG_MUSIC_DIR") PS1L+="";;
		"$XDG_PICTURES_DIR") PS1L+="";;
		"$XDG_VIDEOS_DIR") PS1L+="󰕧";;
		*) PS1L+="";;
	esac
	PS1L+="\]"
	PS1L+=" \$(__prompt_cwd \"\w\") "

	PS1L+="\[\e[0;1;38;2;24;24;37m\]"
	PS1L+=" \[\e[1D\]"
	PS1L+="\[\e[0m\]"
	PS1L+=" "

	PS1R=""

	if [ "$exit" != 0 ]; then
		PS1R+="\[\e[1;31m\]$exit  \[\e[1D\] "
	fi

	if [ -n "$timer" ]; then
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
	fi

	if [ -n "${PS1R// /}" ]; then
		PS1R_="$PS1R"
		PS1R=""

		PS1R+="\[\e[1;38;2;24;24;37m\]"
		PS1R+=" \[\e[1D\]"
		PS1R+="\[\e[48;2;24;24;37m\] "

		PS1R+="$PS1R_"

		PS1R+="\[\e[0;1;38;2;24;24;37m\]"
		PS1R+=" \[\e[1D\]"
		PS1R+="\[\e[0m\]"
	fi

	PS1R_stripped="${PS1R//\\\[*([^\]])\\\]/}"
	PS1R="${PS1R//@(\\\[|\\\])/}"

	PS1="\[$(tput sc)\]\[\e[$(tput cols)C\e[${#PS1R_stripped}D$PS1R$(tput rc)\]$PS1L"
}

# prompt current working directory

__prompt_cwd() {
	local path="$1"
	local maximum_length="$(($(tput cols) / 4))"

	local separator="/"
	local ellipsis="…";

	local parent=""
	local name="$path"
	if [[ $path =~ ^(.*$separator)([^$separator]+)$ ]]; then
		parent="${BASH_REMATCH[1]}"
		name="${BASH_REMATCH[2]}"
	fi
	if (( ${#path} > maximum_length )); then
		parent="${parent:$((${#parent} + ${#ellipsis} + ${#separator} + ${#name} - maximum_length))}"
		if [[ $parent =~ [^$separator]*$separator?(.*)$ ]]; then
			parent="${BASH_REMATCH[1]}"
		fi
		parent="\001$(tput sc)\002 \001$(tput rc)$ellipsis\002$separator$parent"
	fi

	echo -e "$parent\001\e[0;1;48;2;24;24;37m\002$name"
}

# prompt timer

__prompt_timer_id="$USER.$BASHPID"
__prompt_timer_start() {
	date +%s.%N > "${TMPDIR:-/tmp}/$__prompt_timer_id.__prompt_timer"
}
__prompt_timer_end() {
	if [ -f "${TMPDIR:-/tmp}/$__prompt_timer_id.__prompt_timer" ]; then
		awk \
			-v start="$(cat "${TMPDIR:-/tmp}/$__prompt_timer_id.__prompt_timer")"\
			-v end="$(date +%s.%N)"\
			"BEGIN { printf(\"%.2f\", end - start) }"
		command rm "${TMPDIR:-/tmp}/$__prompt_timer_id.__prompt_timer" &> /dev/null
	fi
}
__prompt_timer_start
trap "command rm \"\${TMPDIR:-/tmp}/\$__prompt_timer_id.__prompt_timer\" &> /dev/null" EXIT

# fetch only once

if command -v neofetch &> /dev/null; then
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

if command -v dircolors &> /dev/null; then
    if [ -r "$HOME/.dircolors" ]; then
		eval "$(dircolors -b "$HOME/.dircolors")"
	else
		eval "$(dircolors -b)"
	fi

	eval "$(dircolors -b <(echo "DIR 1;38;2;203;166;247"))"

	function ls() { command ls -lsh --color "$@" | tail -n +2; }
    alias dir="dir --color=auto"
    alias vdir="vdir --color=auto"

    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
else
	function ls() { command ls -lsh "$@" | tail -n +2; }
fi

cd() { builtin cd "$@" && ls .; }

# create alias for managing configuration

if command -v git &> /dev/null; then
	ENABLE_DOTFILES=false

	if [ -d "$HOME/.dotfiles/" ]; then
		if git -C "$HOME/.dotfiles/" rev-parse --is-inside-git-dir &> /dev/null; then
			ENABLE_DOTFILES=true
		fi
	else
		git init --bare "$HOME/.dotfiles"
		git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" config status.showUntrackedFiles no
		git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" remote add origin "https://github.com/TarekSaeed0/.dotfiles"
		ENABLE_DOTFILES=true
	fi

	if [ "$ENABLE_DOTFILES" = true ]; then
		alias dotfiles="git --git-dir=\"\$HOME/.dotfiles/\" --work-tree=\"\$HOME\""
		if [ -r "/usr/share/bash-completion/bash_completion" ]; then
			_completion_loader git
			complete -o bashdefault -o default -o nospace -F __git_wrap__git_main dotfiles
		fi
	fi

	unset -v ENABLE_DOTFILES
fi

# source command not found if installed

if [ -r "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
  . "/usr/share/doc/pkgfile/command-not-found.bash"
fi
