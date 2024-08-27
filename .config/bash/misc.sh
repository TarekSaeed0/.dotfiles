#!/bin/bash

tabs -4

if command -v fzf &>/dev/null; then
	export FZF_DEFAULT_OPTS="--tmux 75%"
	export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
		--color=fg:#cdd6f4,fg+:#cdd6f4,bg:#1e1e2e,bg+:#313244
		--color=hl:#f5c2e7,hl+:#f5c2e7,info:#6c7086,marker:#f9e2af
		--color=prompt:#94e2d5,spinner:#af5fff,pointer:#94e2d5,header:#cba6f7
		--color=border:#6c7086,label:#cba6f7,query:#cdd6f4
		--border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
		--marker="+" --pointer=">" --separator="─" --scrollbar="▐"
		--info="right"'

	export FZF_CTRL_T_OPTS='--walker-skip .git,node_modules,target --preview "bat --color=always {} 2>/dev/null || exa -lgM --git --color=always --icons=always {} | sed \"s///g\" | sed \"s///g\""'
	export FZF_ALT_C_OPTS='--walker-skip .git,node_modules,target --preview "exa -lgM --git --color=always --icons=always {} | sed \"s///g\" | sed \"s///g\""'

	eval "$(fzf --bash)"
fi
