#!/bin/bash

if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
	# FIX: running this on termux makes tmux give an error
	if ! command -v termux-setup-storage &>/dev/null; then
		session="$(tmux list-sessions -F \
			'#{session_attached} #{?#{==:#{session_last_attached},},1,#{session_last_attached}} #{session_id}' 2>/dev/null |
			awk '/^0/ { if ($2 > t) { t = $2; s = $3 } }; END { if (s) printf "%s", s }')"
	fi

	case "$TERM" in
	*kitty*)
		export SNACKS_KITTY=true
		;;
	esac

	if [ -n "$session" ]; then
		tmux attach-session -t "$session" && exit
	else
		tmux new-session && exit
	fi
fi
