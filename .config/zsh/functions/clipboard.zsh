# copy input to clipboard 

function clipboard-copy() {
	if (( $+commands[wl-copy] )); then
		wl-copy --trim-newline
  elif (( $+commands[termux-clipboard-set] )); then
    termux-clipboard-set
  elif [[ -n "$TMUX" ]] && (( ${+commands[tmux]} )); then
    tmux load-buffer -w -
	else
		print "No clipboard utility found" >&2
		return 1
	fi
}

# paste clipboard to output 

function clipboard-paste() {
	if (( $+commands[wl-paste] )); then
		wl-paste --no-newline
  elif (( $+commands[termux-clipboard-get] )); then
    termux-clipboard-get
  elif [ -n "${TMUX:-}" ] && (( ${+commands[tmux]} )); then
    tmux save-buffer -;
	else
		print "No clipboard utility found" >&2
		return 1
	fi
}
