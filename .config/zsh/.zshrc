# History

if [ ! -d "$XDG_STATE_HOME/zsh" ]; then
	mkdir -p "$XDG_STATE_HOME/zsh"
fi

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=9000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Keybindings

bindkey -e

# Options

setopt extendedglob
setopt autocd

# Completions

if [ ! -d "$XDG_CACHE_HOME/zsh" ]; then
	mkdir -p "$XDG_CACHE_HOME/zsh"
fi

zstyle :compinstall filename "$ZDOTDIR/.zshrc"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# Suggestions

if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

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

if (( $+commands[exa] )); then
	EXA_COLORS="da=38;2;137;220;235:"

	EXA_COLORS+="uu=38;2;203;166;247:"
	EXA_COLORS+="gu=38;2;203;166;247:"

	EXA_COLORS+="un=38;2;180;190;254:"
	EXA_COLORS+="gn=38;2;180;190;254:"

	EXA_COLORS+="uR=38;2;180;190;254:"
	EXA_COLORS+="gR=38;2;180;190;254:"

	EXA_COLORS+="ur=38;2;137;220;235:"
	EXA_COLORS+="gr=38;2;137;220;235:"
	EXA_COLORS+="tr=38;2;137;220;235:"

	EXA_COLORS+="uw=38;2;116;199;236:"
	EXA_COLORS+="gw=38;2;116;199;236:"
	EXA_COLORS+="tw=38;2;116;199;236:"

	EXA_COLORS+="ux=38;2;203;166;247:"
	EXA_COLORS+="ue=38;2;203;166;247:"
	EXA_COLORS+="gx=38;2;203;166;247:"
	EXA_COLORS+="tx=38;2;203;166;247:"

	EXA_COLORS+="xa=38;2;108;112;134:"
	EXA_COLORS+="xx=38;2;108;112;134:"

	EXA_COLORS+="bu=4;38;2;242;205;205:"
	EXA_COLORS+="sc=38;2;242;205;205:"

	EXA_COLORS+="sn=38;2;166;227;161:"
	EXA_COLORS+="sb=38;2;166;227;161:"

	EXA_COLORS+="ln=38;2;116;199;236:"
	EXA_COLORS+="lp=38;2;116;199;236:"

	export EXA_COLORS
fi

export XCURSOR_SIZE=24

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source "$ZDOTDIR/themes/catppuccin-mocha-zsh-syntax-highlighting.zsh"
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

for shell_component in multiplexer functions aliases misc prompt; do
	if [[ -r "$ZDOTDIR/$shell_component.zsh" ]]; then
		source "$ZDOTDIR/$shell_component.zsh"
	fi
done
