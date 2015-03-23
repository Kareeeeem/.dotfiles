# modified version of https://gist.github.com/joshdick/4415470
GIT_PROMPT_UNTRACKED="%F{red}*%f"
GIT_PROMPT_MODIFIED="%F{yellow}*%f"
GIT_PROMPT_STAGED="%F{green}*%f"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {

    # Compose this value via multiple conditional appends.
    local GIT_STATE="%F{green}"
    if [[ -n $(git status --porcelain 2> /dev/null) ]]; then
        GIT_STATE="%F{red}"
    fi


    # if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    #     GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
    # fi

    # if ! git diff --quiet 2> /dev/null; then
    #     GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
    # fi

    # if ! git diff --cached --quiet 2> /dev/null; then
    #     GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
    # fi

    if [[ -n $GIT_STATE ]]; then
        echo "$GIT_STATE"
    fi
}

# If inside a Git repository, print its branch and state
# git_prompt_string() {
#     local git_where="$(parse_git_branch)"
#     [ -n "$git_where" ] && echo "git:${git_where#(refs/heads/|tags/)}$(parse_git_state) "
# }

git_prompt_string() {
    local git_where="$(parse_git_branch)"
    [ -n "$git_where" ] && echo "git:$(parse_git_state)${git_where#(refs/heads/|tags/)}%f "
}
