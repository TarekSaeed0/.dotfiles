for function_component in cd ls cat diff clipboard retry dotfiles create-project loadenv list-package-sizes; do
	if [[ -r "$ZDOTDIR/functions/${function_component}.zsh" ]]; then
		source "$ZDOTDIR/functions/${function_component}.zsh"
	fi
done
