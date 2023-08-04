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
		parent="$ellipsis$separator$parent"
	fi

	echo -e "$parent\001\e[1;38;2;205;214;244m\002$name"
}

PS1=""
PS1+="\[\e[1;38;2;137;180;250m\]"
PS1+="\[$(tput sc)\] \[$(tput rc)\]"
PS1+="\[\e[0;38;2;49;50;68;48;2;137;180;250m\]"
PS1+=" \[$(tput sc)\]  \[$(tput rc) \]"
PS1+="\[\e[1m\]"
PS1+="\u "
PS1+="\[\e[1;38;2;137;180;250;48;2;24;24;37m\]"
PS1+="\[$(tput sc)\] \[$(tput rc)\]"
PS1+="\[\e[0;38;2;108;112;134;48;2;24;24;37m\]"
PS1+="  \[$(tput sc)\] \[$(tput rc)\]"
PS1+="  \$(_prompt_cwd \"\w\") "
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

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"
export NPM_CONFIG_INIT_MODULE="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npm-init.js"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/npm"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/npm"
export PATH="$PATH:${XDG_DATA_HOME:-$HOME/.local/share}/npm/bin"

export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"

alias dotfiles="/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME"

[[ $0 == -* ]] && neofetch
