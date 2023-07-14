[[ $- != *i* ]] && return

prompt_current_working_directory() {
	local maximum_length="$(($(tput cols) / 3))"

	local path="$1"
	local path_separator="/"
	local path_components; IFS="$path_separator" read -ra path_components <<< "$path$path_separator"

	local parent=""
	local name="${path_components[-1]}"

	local s="…";
	local length="$((${#s} + ${#path_separator} + ${#name}))"
	for ((i = ${#path_components[@]} - 2; i >= 0; i--)); do
		local path_component="${path_components[i]}"

		length="$((length + ${#path_component} + ${#path_separator}))"
		if ((length > maximum_length)); then
			parent="\001$(tput sc)\002 \001$(tput rc)…\002$path_separator$parent"
			break
		fi

		parent="$path_component$path_separator$parent"
	done
	if [[ "$name" == "" ]]; then
		name="$parent";
		parent=""
	fi

	echo -e "$parent\001\e[1;38;2;205;214;244m\002$name"
}

PS1=""
PS1+="\[\e[1;38;2;137;180;250m\]"
PS1+="\[$(tput sc)\] \[$(tput rc)\]"
PS1+="\[\e[0;38;2;49;50;68;48;2;137;180;250m\]"
PS1+=" \[$(tput sc)\] \[$(tput rc)\]"
PS1+="\[\e[1m\]"
PS1+=" \u@\h "
PS1+="\[\e[1;38;2;137;180;250;48;2;24;24;37m\]"
PS1+="\[$(tput sc)\] \[$(tput rc)\]"
PS1+="\[\e[0;38;2;108;112;134;48;2;24;24;37m\]"
PS1+="  \[$(tput sc)\] \[$(tput rc)\]"
PS1+="  \$(prompt_current_working_directory \"\w\") "
PS1+="\[\e[0;1;38;2;24;24;37m\]"
PS1+="\[$(tput sc)\] \[$(tput rc)\]"
PS1+="\[\e[0m\]"
PS1+=" "

alias ls="ls -lsh --color=auto"
alias rm="rm -i"
cd() { builtin cd "$@" && ls; }

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"
export NPM_CONFIG_INIT_MODULE="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npm-init.js"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/npm"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/npm"
export PATH="$PATH:${XDG_DATA_HOME:-$HOME/.local/share}/npm/bin"

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

neofetch
