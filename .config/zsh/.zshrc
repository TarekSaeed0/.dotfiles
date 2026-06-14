# Options

setopt EXTENDED_GLOB
setopt AUTO_CD

# Editor

if (( $+commands[nvim] )); then
	export EDITOR="nvim"
	export MANPAGER="nvim +Man!"
fi

# Other Programs

if (( $+commands[adb] )); then
	alias adb="[ -d \"\$ANDROID_USER_HOME\" ] || mkdir -p \"\$ANDROID_USER_HOME\"; HOME=\"\$ANDROID_USER_HOME\" adb"
fi

if (( $+commands[wget] )); then
	export WGETRC="$XDG_CONFIG_HOME/wgetrc"
	alias wget="wget --hsts-file=\"\$XDG_DATA_HOME/wget-hsts\""
fi

if (( $+commands[sqlite3] )); then
	if [ ! -d "$XDG_STATE_HOME/sqlite" ]; then
		mkdir -p "$XDG_STATE_HOME/sqlite"
	fi

	export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite/history"
fi

export XCURSOR_SIZE=24

# Load components

for shell_component in history key-bindings completion multiplexer functions aliases misc prompt; do
	if [[ -r "$ZDOTDIR/$shell_component.zsh" ]]; then
		source "$ZDOTDIR/$shell_component.zsh"
	fi
done

# Suggestions

if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax Highlighting

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source "$ZDOTDIR/themes/catppuccin-mocha-zsh-syntax-highlighting.zsh"
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
