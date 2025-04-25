#!/bin/bash

_create_project_completion() {
	local cur prev words cword comp_args
	_comp_initialize -n = -- "$@" || return

	# get the templates list
	local templates_directory="$XDG_CONFIG_HOME/nvim/templates"
	local templates
	templates="$(basename -a "$templates_directory"/* 2>/dev/null)"

	if [[ "$cur" == template=* ]]; then
		local cur_="${cur#template=}"
		COMPREPLY=($(compgen -W "$templates" -- "$cur_"))
	else
		# check if the template is already specified
		local is_template_specified=0
		for i in "${words[@]}"; do
			if [[ "$i" == template=* ]]; then
				is_template_specified=1
				break
			fi
		done

		if [[ "$is_template_specified" -eq 0 ]]; then
			COMPREPLY=($(compgen -W "template=" -- "$cur"))
		fi
	fi

	if [[ ! "${COMPREPLY[*]}" =~ "=" ]]; then
		# add space if there is not a '=' in the completions
		compopt +o nospace
	fi
}

complete -o nospace -F _create_project_completion create_project
