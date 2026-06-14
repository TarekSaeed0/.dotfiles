setopt PROMPT_SUBST

ZLE_RPROMPT_INDENT=0

for prompt_component in git location virtual-environment status timer; do
	if [[ -r "$ZDOTDIR/prompt/${prompt_component}.zsh" ]]; then
		source "$ZDOTDIR/prompt/${prompt_component}.zsh"
	fi
done

PROMPT='\
%B%F{#cba6f7}\
%F{#181825}%K{#cba6f7}  %B%n \
%F{#cba6f7}%K{#181825}\
%b%F{#6c7086}\
$(__prompt_git)\
$(__prompt_location)\
$(__prompt_virtual_environment)\
%k%B%F{#181825}\
%f%k%b \
'

function __prompt_right() {
	local right_prompt=""

	local status_output="$(__prompt_status)"
	local timer_output="$(__prompt_timer)"
	if [[ ( -n "$status_output" || -n "$timer_output" ) && "$TERM_PROGRAM" != "vscode" ]]; then
		right_prompt+='%B%F{#181825}%b%F{#6c7086}%K{#181825} '
		right_prompt+="$status_output"
		right_prompt+="$timer_output"
		right_prompt+='%k%B%F{#181825}%f%k%b'
	fi

	print "$right_prompt"
}

RPROMPT='$(__prompt_right)'
