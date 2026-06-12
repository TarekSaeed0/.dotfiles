# XDG Base Directory Specification (https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"

# Other Programs

if (( $+commands[clang] )); then
	export CC="clang"
fi
if (( $+commands[clang++] )); then
	export CXX="clang++"
fi

if (( $+commands[npm] )); then
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
	export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/npm-init.js"
	export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
	export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
	path+=("$XDG_DATA_HOME/npm/bin")
fi

if (( $+commands[rustup] )); then
	export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
	path+=("$(dirname "$(rustup which rustc)")")
fi

if (( $+commands[cargo] )); then
	export CARGO_HOME="$XDG_DATA_HOME/cargo"
	path+=("$CARGO_HOME/bin")
fi

if (( $+commands[python] )); then
	export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
fi

if (( $+commands[java] )); then
	export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java -Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx"
fi

export KERAS_HOME="${XDG_STATE_HOME}/keras"

if (( $+commands[flutter] )); then
	export FLUTTER_ROOT="/usr/lib/flutter"
fi

if (( $+commands[fvm] )); then
	export FVM_CACHE_PATH="$XDG_CACHE_HOME/fvm"
	export FVM_USE_GIT_CACHE="false"
fi

if (( $+commands[iceauth] )); then
	export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
fi

if (( $+commands[gpg] )); then
	export GNUPGHOME="$XDG_DATA_HOME/gnupg"
fi

export ANDROID_HOME="$XDG_DATA_HOME/android/sdk"
path+=(
	"$ANDROID_HOME/emulator"
	"$ANDROID_HOME/tools"
	"$ANDROID_HOME/tools/bin"
	"$ANDROID_HOME/platform-tools"
)
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
export ANDROID_EMULATOR_HOME="$ANDROID_USER_HOME"
export ANDROID_AVD_HOME="$ANDROID_EMULATOR_HOME/avd"
if [ -d "$ANDROID_HOME/ndk" ]; then
	local ndk_directories=("$ANDROID_HOME/ndk"/*(N/))
	if (( ${#ndk_directories} > 0 )); then
		export NDK_HOME="${ndk_directories[-1]}"
	fi
fi

if (( $+commands[gradle] )); then
	export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
fi

export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"

if (( $+commands[R] )); then
	export R_ENVIRON_USER="$XDG_CONFIG_HOME/R/environ"
	export R_PROFILE_USER="$XDG_CONFIG_HOME/R/profile"
	export R_LIBS_USER="$XDG_DATA_HOME/R/x86_64-pc-linux-gnu-library"
	export R_HISTFILE="$XDG_STATE_HOME/R/history"
fi

export G2TP_OVMF_IMAGE="/usr/share/ovmf/x64/OVMF_CODE.4m.fd"

if (( $+commands[firefox] )); then
	export BROWSER="firefox"
fi

if (( $+commands[jupyter] )); then
	export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
fi

if (( $+commands[ipython] )); then
	export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
fi

if (( $+commands[dotnet] )); then
	export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
fi

if (( $+commands[wine] )); then
	[ -d "$XDG_DATA_HOME/wineprefixes" ] || mkdir -p "$XDG_DATA_HOME/wineprefixes"
	export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
fi

if (( $+commands[docker] )); then
	export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
fi

export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc:$XDG_CONFIG_HOME/gtk-2.0/gtkrc.mine"

# Add user local bin to PATH

if [ -d "$HOME/.local/bin" ]; then
	path=("$HOME/.local/bin" $path)
fi

typeset -U path
