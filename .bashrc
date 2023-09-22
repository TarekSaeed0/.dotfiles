[[ $- != *i* ]] && return

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/usr/$UID}"

export HISTFILE="$XDG_STATE_HOME/bash/history"
export HISTSIZE=10000
export HISTCONTROL="ignoredups"

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/npm-init.js"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export PATH="$PATH:$XDG_DATA_HOME/npm/bin"

export CARGO_HOME="$XDG_DATA_HOME/cargo"

export MANPAGER="nvim +Man!"

_prompt_cwd() {
	local path="$1"
	local maximum_length="$(($(tput cols) / 4))"

	local separator="/"
	local ellipsis="…";

	local parent="" name="$path"
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

	echo -e "$parent\001\e[1;38;2;205;214;244m\002$name"
}

PS1=""
PS1+="\[\e[1;38;2;137;180;250m\]"
PS1+="\[$(tput sc)\] \[$(tput rc)\]"
PS1+="\[\e[0;38;2;24;24;37;48;2;137;180;250m\]"
PS1+=" \[$(tput sc)\]  \[$(tput rc) \]"
PS1+="\[\e[1m\]"
PS1+="\u "
PS1+="\[\e[1;38;2;137;180;250;48;2;24;24;37m\]"
PS1+="\[$(tput sc)\] \[$(tput rc)\]"
PS1+="\[\e[0;38;2;108;112;134;48;2;24;24;37m\]"
PS1+=" \[$(tput sc)\]  \[$(tput rc) \]"
PS1+=" \$(_prompt_cwd \"\w\") "
PS1+="\[\e[0;1;38;2;24;24;37m\]"
PS1+="\[$(tput sc)\] \[$(tput rc)\]"
PS1+="\[\e[0m\]"
PS1+=" "

alias rm="rm -i"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls="ls -lsh --color=auto"
    alias dir="dir --color=auto"
    alias vdir="vdir --color=auto"

    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
else
	alias ls="ls -lsh"
fi

cd() { builtin cd "$@" && ls; }

if command -v git &> /dev/null; then
	if [ -d "$HOME/.dotfiles/" ]; then
		if git -C "$HOME/.dotfiles/" rev-parse --is-inside-git-dir &> /dev/null; then
			alias dotfiles="git --git-dir=\"\$HOME/.dotfiles/\" --work-tree=\"\$HOME\""
		fi
	else
		git init --bare "$HOME/.dotfiles"
		git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" config status.showUntrackedFiles no
		git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" remote add origin "https://github.com/TarekSaeed0/.dotfiles"
		alias dotfiles="git --git-dir=\"\$HOME/.dotfiles/\" --work-tree=\"\$HOME\""
	fi
fi

if command -v neofetch &> /dev/null && ([[ $0 == -* ]] || ! [ -v NEOFETCH_STARTUP ]); then
	export NEOFETCH_STARTUP=""
	neofetch
fi
