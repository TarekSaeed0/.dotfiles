# return if not interactive

case $- in
*i*) ;;
*) return ;;
esac

# start tmux session if not already in one

if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
	# find an unattached session
	session="$(tmux list-sessions -F \
		'#{session_attached} #{?#{==:#{session_last_attached},},1,#{session_last_attached}} #{session_id}' 2>/dev/null |
		awk '/^0/ { if ($2 > t) { t = $2; s = $3 } }; END { if (s) printf "%s", s }')"

	if [ -n "$session" ]; then
		tmux attach-session -t "$session" && exit
	else
		tmux new-session && exit
	fi
fi

# prompt

for component in git location; do
	if [ -r "$XDG_CONFIG_HOME/bash/prompt/${component}.sh" ]; then
		. "$XDG_CONFIG_HOME/bash/prompt/${component}.sh"
	fi
done

export __prompt_timer_id="$USER.$BASHPID"
if [ -r "$XDG_CONFIG_HOME/bash/prompt/timer.sh" ]; then
	. "$XDG_CONFIG_HOME/bash/prompt/timer.sh" "$__prompt_timer_id"
fi

PS0="\$(__prompt_timer_start \"\$__prompt_timer_id\")"

PROMPT_COMMAND="__prompt_command"
__prompt_command() {
	local exit="$?"

	__prompt_timer_end "$__prompt_timer_id"

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
	timer="$(__prompt_timer "$__prompt_timer_id")"
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

if [ -r "$XDG_CONFIG_HOME/bash/fetch.sh" ]; then
	. "$XDG_CONFIG_HOME/bash/fetch.sh"
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

	alias dir="dir --color=auto"
	alias vdir="vdir --color=auto"

	alias grep="grep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias egrep="egrep --color=auto"
fi

# source command not found if installed

if [ -r "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
	. "/usr/share/doc/pkgfile/command-not-found.bash"
fi

for component in cd.sh ls.sh cat.sh retry.sh dotfiles.sh; do
	if [ -r "$XDG_CONFIG_HOME/bash/functions/$component" ]; then
		. "$XDG_CONFIG_HOME/bash/functions/$component"
	fi
done
