#!/bin/bash

if [ -r "/usr/share/git/git-prompt.sh" ]; then
	. "/usr/share/git/git-prompt.sh"
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWCOLORHINTS=
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWUPSTREAM="auto git"

PROMPT_GIT_FILE="${TMPDIR:-/tmp}/__prompt.$__prompt_id.git"
PROMPT_GIT_CACHE_KEY_FILE="$PROMPT_GIT_FILE.cache.key"
PROMPT_GIT_CACHE_VALUE_FILE="$PROMPT_GIT_FILE.cache.value"

PROMPT_GIT_CACHE_TTL=60

touch "$PROMPT_GIT_CACHE_KEY_FILE"
touch "$PROMPT_GIT_CACHE_VALUE_FILE"

__prompt_git_modification_time() {
	local file="$1"

	if [ -e "$file" ]; then
		stat -c %Y "$file" 2>/dev/null
	else
		echo 0
	fi
}

__prompt_git_cache_key() {
	local git_directory
	git_directory=$(git rev-parse --absolute-git-dir 2>/dev/null) || return 1

	local bucket
	bucket=$(( $(date +%s) / PROMPT_GIT_CACHE_TTL ))

	echo "$git_directory|$bucket|$(__prompt_git_modification_time "$git_directory/HEAD")|$(__prompt_git_modification_time "$git_directory/index")|$(__prompt_git_modification_time "$git_directory/MERGE_HEAD")|$(__prompt_git_modification_time "$git_directory/rebase-merge/head-name")|$(__prompt_git_modification_time "$git_directory/rebase-apply/head-name")|$(__prompt_git_modification_time "$git_directory/logs/refs/stash")"
}

__prompt_git_update() {
	local key
	key=$(__prompt_git_cache_key) || {
		echo "" >"$PROMPT_GIT_CACHE_VALUE_FILE"
		echo "" >"$PROMPT_GIT_CACHE_KEY_FILE"
		return
	}

	local previous_key
	previous_key=$(<"$PROMPT_GIT_CACHE_KEY_FILE")

	if [ "$key" = "$previous_key" ]; then
		return
	fi

	local value
	value=$(__git_ps1 "%s")
	echo "$value" >"$PROMPT_GIT_CACHE_VALUE_FILE"
	echo "$key" >"$PROMPT_GIT_CACHE_KEY_FILE"
}

__prompt_git() {
	__prompt_git_update
	
	local value
	value=$(<"$PROMPT_GIT_CACHE_VALUE_FILE")

	if [ -n "$value" ]; then
		echo -ne " \001\e[1D\002 $value "
	fi
}

trap 'command rm "$PROMPT_GIT_CACHE_KEY_FILE" "$PROMPT_GIT_CACHE_VALUE_FILE"' EXIT
