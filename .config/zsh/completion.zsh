setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

if [ ! -d "$XDG_CACHE_HOME/zsh" ]; then
	mkdir -p "$XDG_CACHE_HOME/zsh"
fi

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
