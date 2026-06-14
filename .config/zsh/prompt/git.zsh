zmodload zsh/datetime

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' check-for-staged-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git*' formats '  %b %c%u%m'
zstyle ':vcs_info:git*' actionformats '  %b|%a%c%u%m'
zstyle ':vcs_info:git:*' patch-format '%n/%a'

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-stash git-upstream

function +vi-git-untracked() {
	if [[ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]]; then
		hook_com[unstaged]+='%%'
	fi
}

function +vi-git-stash() {
	if git rev-parse --verify refs/stash &>/dev/null; then
		hook_com[misc]+='$'
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

__prompt_git() {
	print "${__prompt_git_value}"
}

__PROMPT_GIT_CACHE_TTL=60

typeset -A __prompt_git_cache

function __prompt_git_modification_time() {
	local file="$1"
	
	if [[ -e "$file" ]]; then
		zstat +mtime "$file" 2>/dev/null
	else
		print 0
	fi
}

function __prompt_git_cache_key() {
	local git_directory=$(git rev-parse --absolute-git-dir 2>/dev/null) || return 1
	local bucket=$(( EPOCHSECONDS / __PROMPT_GIT_CACHE_TTL ))
	local head_mtime=$(__prompt_git_modification_time "$git_directory/HEAD")
	local index_mtime=$(__prompt_git_modification_time "$git_directory/index")
	local merge_head_mtime=$(__prompt_git_modification_time "$git_directory/MERGE_HEAD")
	local rebase_merge_mtime=$(__prompt_git_modification_time "$git_directory/rebase-merge/head-name")
	local rebase_apply_mtime=$(__prompt_git_modification_time "$git_directory/rebase-apply/head-name")
	local stash_mtime=$(__prompt_git_modification_time "$git_directory/logs/refs/stash")
	
	print "$git_directory|$bucket|$head_mtime|$index_mtime|$merge_head_mtime|$rebase_merge_mtime|$rebase_apply_mtime|$stash_mtime"
}

function __prompt_git_precmd() {
	local key="$(__prompt_git_cache_key)" || return

	if [[ -z "${__prompt_git_cache[$key]}" ]]; then
		vcs_info
		__prompt_git_cache[$key]="${vcs_info_msg_0_}"
	fi

	__prompt_git_value="${__prompt_git_cache[$key]}"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __prompt_git_precmd

