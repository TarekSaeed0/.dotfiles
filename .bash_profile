if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"

if [ ! -d "$XDG_STATE_HOME/bash" ]; then
	mkdir -p "$XDG_STATE_HOME/bash"
fi
export HISTFILE="$XDG_STATE_HOME/bash/history"
export HISTSIZE=10000
export HISTCONTROL="ignoreboth"

if command -v nvim &> /dev/null; then
	export EDITOR="nvim"
	export MANPAGER="nvim +Man!"
fi

if command -v clang &> /dev/null; then
	export CC="clang"
fi
if command -v clang++ &> /dev/null; then
	export CXX="clang++"
fi

if command -v npm &> /dev/null; then
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
	export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/npm-init.js"
	export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
	export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
	export PATH="$PATH:$XDG_DATA_HOME/npm/bin"
fi

if command -v rustup &> /dev/null; then
	export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
fi
if command -v cargo &> /dev/null; then
	export CARGO_HOME="$XDG_DATA_HOME/cargo"
	export PATH="$PATH:$CARGO_HOME/bin"
fi

if command -v iceauth &> /dev/null; then
	export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
fi

if command -v gpg &> /dev/null; then
	export GNUPGHOME="$XDG_DATA_HOME/gnupg"
fi

if command -v adb &> /dev/null; then
	alias adb="[ -d \"\$XDG_DATA_HOME/android\" ] || mkdir -p \"\$XDG_DATA_HOME/android\"; HOME=\"\$XDG_DATA_HOME/android\" adb"
fi

if command -v wine &> /dev/null || command -v wine64 &> /dev/null; then
	if [ ! -d "$XDG_DATA_HOME/wine/prefixes" ]; then
		mkdir -p "$XDG_DATA_HOME/wine/prefixes"
	fi
	export WINEPREFIX="$XDG_DATA_HOME/wine/prefixes/default"
fi

if command -v wget &> /dev/null; then
	alias wget="wget --hsts-file=\"\$XDG_DATA_HOME/wget-hsts\""
fi

if command -v sqlite3 &> /dev/null; then
	export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history"
fi

if [ -r "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
