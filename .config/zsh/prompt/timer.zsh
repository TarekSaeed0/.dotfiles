zmodload zsh/datetime
zmodload zsh/mathfunc

function __prompt_timer_get_time() {
	echo $EPOCHREALTIME
}

function __prompt_timer_preexec() {
	__prompt_timer_start_time=$(__prompt_timer_get_time)
}

function __prompt_timer_precmd() {
	unset __prompt_timer_duration
	if [[ -n "$__prompt_timer_start_time" ]]; then
		__prompt_timer_duration=$(( $(__prompt_timer_get_time) - __prompt_timer_start_time ))

		unset __prompt_timer_start_time
	fi
}

function __prompt_timer_format() {
	float duration="${1:-0}"
	local time=""
	
	integer hours=$(( duration / 3600 ))
	if (( hours > 0 )); then
		time+="${hours}h "
	fi
	
	integer minutes=$(( (duration % 3600) / 60 ))
	if (( minutes > 0 )); then
		time+="${minutes}m "
	fi
	
	float seconds=$(( duration % 60 ))
	if (( seconds != 0 )) || [[ -z "$time" ]]; then
		integer decimals=2
		if (( seconds != 0 && seconds < 0.1 )); then
			decimals=$(( ceil(abs(log10(seconds))) + 1 ))
		fi
		time+="${${$(printf "%.${decimals}f" "$seconds")%%0#}%.}s"
	fi
	
	echo "${time%% }"
}

function __prompt_timer() {
	if [[ -n "$__prompt_timer_duration" ]]; then
		local formatted_time=$(__prompt_timer_format "$__prompt_timer_duration")
		print "${formatted_time}  "
	fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec __prompt_timer_preexec
add-zsh-hook precmd __prompt_timer_precmd
