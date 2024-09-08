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

__prompt_git() {
	if git branch --no-color &>/dev/null; then
		echo -ne " \001\e[1D\002 $(__git_ps1 "%s") "
	fi
}
