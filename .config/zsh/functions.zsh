#!/bin/zsh

for function_component in cd ls cat diff retry dotfiles create_project; do
	if [[ -r "$ZDOTDIR/functions/${function_component}.zsh" ]]; then
		source "$ZDOTDIR/functions/${function_component}.zsh"
	fi
done
