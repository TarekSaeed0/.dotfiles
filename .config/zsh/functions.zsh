#!/bin/zsh

local function
for function in cd ls cat diff retry dotfiles create_project; do
	if [[ -r "$ZDOTDIR/functions/${function}.zsh" ]]; then
		source "$ZDOTDIR/functions/${function}.zsh"
	fi
done