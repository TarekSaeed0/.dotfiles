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

# __prompt_git() {
# 	if [ -d .git ] || git rev-parse --git-dir &>/dev/null; then
# 		echo -ne " \001\e[1D\002 $(__git_ps1 "%s") "
# 	fi
# }

PROMPT_GIT_FILE="${TMPDIR:-/tmp}/__prompt.$__prompt_id.git"
PROMPT_GIT_LOCK_FILE="$PROMPT_GIT_FILE.lock"
PROMPT_GIT_INFO_FILE="$PROMPT_GIT_FILE.info"

touch "$PROMPT_GIT_INFO_FILE"

__prompt_git_update() {
	if [ -d .git ] || git rev-parse --git-dir &>/dev/null; then
		if [ -f "$PROMPT_GIT_LOCK_FILE" ]; then
			return
		fi

		touch "$PROMPT_GIT_LOCK_FILE"

		(
			local info
			info=$(__git_ps1 "%s")

			echo "$info" >"$PROMPT_GIT_INFO_FILE"

			command rm "$PROMPT_GIT_LOCK_FILE"
		) &
		disown "$!"
	else
		echo "" >"$PROMPT_GIT_INFO_FILE"
	fi
}

__prompt_git() {
	local info
	info=$(<"$PROMPT_GIT_INFO_FILE")

	if [ -n "$info" ]; then
		echo -ne " \001\e[1D\002 $info "
	fi
}

trap 'command rm  "$PROMPT_GIT_LOCK_FILE" "$PROMPT_GIT_INFO_FILE"' EXIT
