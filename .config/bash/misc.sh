#!/bin/bash

tabs -4

if command -v fzf &>/dev/null; then
	eval "$(fzf --bash)"

	export FZF_DEFAULT_OPTS="--tmux 75% --bind shift-up:preview-page-up,shift-down:preview-page-down"
	export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
		--color=fg:#cdd6f4,fg+:#cdd6f4,bg:#1e1e2e,bg+:#313244
		--color=hl:#f5c2e7,hl+:#f5c2e7,info:#6c7086,marker:#f9e2af
		--color=prompt:#94e2d5,spinner:#af5fff,pointer:#94e2d5,header:#cba6f7
		--color=border:#6c7086,label:#cba6f7,query:#cdd6f4
		--border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
		--marker="+" --pointer=">" --separator="─" --scrollbar="▐"
		--info="right"'

	ignored_patterns=".git,build,target,venv,.venv,node_modules,$(find -L "$HOME" -mindepth 1 -maxdepth 1 -type d -name ".*" ! -name ".config" -exec basename {} \; | while read -r i; do printf '%q\n' "$i"; done | paste -sd, -),$(find -L "$XDG_CONFIG_HOME" -mindepth 1 -maxdepth 1 -type d ! -regex "$XDG_CONFIG_HOME/\(bash\|nvim\|tmux\|kitty\|git\|neofetch\|btop\|cava\)" -exec basename {} \; | while read -r i; do printf '%q\n' "$i"; done | paste -sd, -)"

	file_previewer='bat --style=numbers --color=always {}'
	directory_previewer='exa -I "'"${ignored_patterns//,/|}"'" -AMTL3 --color=always --icons=always {}  | sed "s///g" | sed "s///g"'
	path_previewer="$file_previewer 2>/dev/null || $directory_previewer"

	export FZF_CTRL_T_OPTS='--walker-skip '"$ignored_patterns"' --preview "'"${path_previewer//\"/\\\"}"'"'
	export FZF_ALT_C_OPTS='--walker-skip '"$ignored_patterns"' --preview "'"${directory_previewer//\"/\\\"}"'"'
	export FZF_COMPLETION_OPTS='--walker-skip '"$ignored_patterns"
	export FZF_COMPLETION_DIR_OPTS='--walker dir,follow,hidden'

	_fzf_comprun() {
		local command=$1
		shift

		case "$command" in
		cd | pushd | rmdir) fzf --preview "$directory_previewer" "$@" ;;
		export | unset | printenv) fzf --preview "eval 'echo \$'{}" "$@" ;;
		unalias | kill | ssh) fzf "$@" ;;
		*) fzf --preview "$path_previewer" "$@" ;;
		esac
	}
fi

if command -v flutter &>/dev/null; then
	eval "$(flutter bash-completion)"
fi

if [ -r /usr/share/doc/pkgfile/command-not-found.bash ]; then
	source /usr/share/doc/pkgfile/command-not-found.bash
fi
