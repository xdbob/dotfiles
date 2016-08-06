# Outputs current branch info in prompt format
function git_prompt_info() {
	local ref
	ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
		ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
	echo "$GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$GIT_PROMPT_SUFFIX"
}

# Checks if working tree is dirty
function parse_git_dirty() {
# The function is disabled (bad perf)
	return
	local STATUS=$(command git status --porcelain 2> /dev/null | tail -n1)
	if [[ -n $STATUS ]]; then
		echo "$GIT_PROMPT_DIRTY"
	else
		echo "$GIT_PROMPT_CLEAN"
	fi
}
