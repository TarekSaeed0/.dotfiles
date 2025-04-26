#!/bin/bash

if command -v git &>/dev/null; then
	_completion_loader git
	complete -o bashdefault -o default -o nospace -F __git_wrap__git_main dotfiles
fi
