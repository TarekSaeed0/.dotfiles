autoload -Uz vcs_info

function __prompt_git_precmd() {
	vcs_info
}

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' check-for-staged-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git*' formats ' %b %c%u%m'
zstyle ':vcs_info:git*' actionformats ' %b|%a%c%u%m'
zstyle ':vcs_info:git:*' patch-format '%n/%a'

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-upstream git-stash

function +vi-git-untracked() {
	if [[ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]]; then
		hook_com[unstaged]+='%%'
	fi
}

function +vi-git-upstream() {
	local ahead=$(git rev-list --count "@{upstream}..HEAD" 2>/dev/null)
	local behind=$(git rev-list --count "HEAD..@{upstream}" 2>/dev/null)

	if [[ "$ahead" -gt 0 && "$behind" -gt 0 ]]; then
		hook_com[misc]+='<>'
	elif [[ "$ahead" -gt 0 ]]; then
		hook_com[misc]+='>'
	elif [[ "$behind" -gt 0 ]]; then
		hook_com[misc]+='<'
	elif git rev-parse @{upstream} &>/dev/null; then
		hook_com[misc]+='='
	fi
}

function +vi-git-stash() {
	if git rev-parse --verify refs/stash &>/dev/null; then
		hook_com[misc]+='$'
	fi
}

__prompt_git() {
	print " ${vcs_info_msg_0_}"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __prompt_git_precmd

