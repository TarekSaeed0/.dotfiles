#!/bin/bash

# command for managing dot files

if command -v git &>/dev/null; then
	dotfiles() {
		if [ -d "$HOME/.dotfiles/" ]; then
			git -C "$HOME/.dotfiles/" rev-parse --is-inside-git-dir &>/dev/null || return 1
		else
			git init --bare "$HOME/.dotfiles"
			git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" config status.showUntrackedFiles no
			git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" remote add origin "https://github.com/TarekSaeed0/.dotfiles"
		fi

		git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
	}
fi
