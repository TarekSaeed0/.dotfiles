[[ $- != *i* ]] && return

_prompt_cwd() {
	local path="$1"
	local maximum_length="$(($(tput cols) / 4))"

	local separator="/"
	local ellipsis="…";

	local parent="" name="$path"
	if [[ $path =~ ^(.*$separator)([^$separator]+)$ ]]; then parent="${BASH_REMATCH[1]}" name="${BASH_REMATCH[2]}"; fi
	if (( ${#path} > maximum_length )); then
		parent="${parent:$((${#parent} + ${#ellipsis} + ${#separator} + ${#name} - maximum_length))}"
		if [[ $parent =~ [^$separator]*$separator?(.*)$ ]]; then parent="${BASH_REMATCH[1]}"; fi
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

alias ls="ls -lshA --color=auto"
alias rm="rm -i"
cd() { builtin cd "$@" && ls; }

export HISTCONTROL="ignoredups"

export CC="/usr/bin/clang"
export CXX="/usr/bin/clang++"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/usr/$UID}"

export HISTFILE="$XDG_STATE_HOME/bash/history"

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/npm-init.js"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export PATH="$PATH:$XDG_DATA_HOME/npm/bin"

export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

export MANPAGER="nvim +Man!"

if command -v man &> /dev/null; then
	alias man="man --config-file=\"\$XDG_CONFIG_HOME/man/config\""
fi
if command -v mandb &> /dev/null; then
	alias mandb="mandb --config-file=\"\$XDG_CONFIG_HOME/man/config\""
fi
if command -v manpath &> /dev/null; then
	alias manpath="manpath --config-file=\"\$XDG_CONFIG_HOME/man/config\""
fi
if command -v apropos &> /dev/null; then
	alias apropos="apropos --config-file=\"\$XDG_CONFIG_HOME/man/config\""
fi

if command -v git &> /dev/null; then
	if [ -d "$HOME/.dotfiles/" ]; then
		if git -C "$HOME/.dotfiles/" rev-parse --is-inside-git-dir &> /dev/null; then
			alias dotfiles="git --git-dir=\"\$HOME/.dotfiles/\" --work-tree=\"\$HOME\""
		fi
	else
		git init --bare "$HOME/.dotfiles"
		git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" config status.showUntrackedFiles no
		alias dotfiles="git --git-dir=\"\$HOME/.dotfiles/\" --work-tree=\"\$HOME\""
	fi
fi

if command -v neofetch &> /dev/null && [[ $0 == -* ]]; then
	neofetch
fi
