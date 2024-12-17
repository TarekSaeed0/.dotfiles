#!/bin/bash

# XDG Base Directory Specification (https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"

# History

if [ ! -d "$XDG_STATE_HOME/bash" ]; then
	mkdir -p "$XDG_STATE_HOME/bash"
fi
export HISTFILE="$XDG_STATE_HOME/bash/history"
export HISTSIZE=10000
export HISTCONTROL="ignoreboth"

# Editor

if command -v nvim &>/dev/null; then
	export EDITOR="nvim"
	export MANPAGER="nvim +Man!"
fi

if command -v clang &>/dev/null; then
	export CC="clang"
fi
if command -v clang++ &>/dev/null; then
	export CXX="clang++"
fi

if command -v npm &>/dev/null; then
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
	export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/npm-init.js"
	export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
	export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
	export PATH="$PATH:$XDG_DATA_HOME/npm/bin"
fi

if command -v rustup &>/dev/null; then
	export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
	export PATH="$PATH:$(dirname "$(rustup which rustc)")"

fi
if command -v cargo &>/dev/null; then
	export CARGO_HOME="$XDG_DATA_HOME/cargo"
	export PATH="$PATH:$CARGO_HOME/bin"
fi

if command -v python &>/dev/null; then
	export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
fi

if command -v flutter &>/dev/null; then
	export FLUTTER_ROOT="/usr/lib/flutter"
fi

if command -v xauth &>/dev/null; then
	export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

fi

if command -v iceauth &>/dev/null; then
	export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
fi

if command -v gpg &>/dev/null; then
	export GNUPGHOME="$XDG_DATA_HOME/gnupg"
fi

export ANDROID_HOME="$XDG_DATA_HOME/android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
export ANDROID_EMULATOR_HOME="$ANDROID_USER_HOME"
export ANDROID_AVD_HOME="$ANDROID_EMULATOR_HOME/avd"
if command -v adb &>/dev/null; then
	alias adb="[ -d \"\$ANDROID_USER_HOME\" ] || mkdir -p \"\$ANDROID_USER_HOME\"; HOME=\"\$ANDROID_USER_HOME\" adb"
fi

if command -v wget &>/dev/null; then
	alias wget="wget --hsts-file=\"\$XDG_DATA_HOME/wget-hsts\""
fi

if command -v sqlite3 &>/dev/null; then
	export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history"
fi

if command -v gradle &>/dev/null; then
	export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
fi

if command -v exa &>/dev/null; then
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

if command -v ollama &>/dev/null; then
	export OLLAMA_MODELS="$XDG_DATA_HOME/ollama/models"
fi

if command -v qt6ct &>/dev/null; then
	export QT_QPA_PLATFORMTHEME=qt6ct
fi

export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc:$XDG_CONFIG_HOME/gtk-2.0/gtkrc.mine"

export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"

export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"

if command -v R &>/dev/null; then
	export R_ENVIRON_USER="$XDG_CONFIG_HOME/R/environ"
	export R_PROFILE_USER="$XDG_CONFIG_HOME/R/profile"
	export R_LIBS_USER="$XDG_DATA_HOME/R/x86_64-pc-linux-gnu-library"
	export R_HISTFILE="$XDG_STATE_HOME/R/history"
fi

if [ -f "/etc/wsl.conf" ]; then
	# manually launch dbus in wsl
	export $(dbus-launch)
fi

if [ -r "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
