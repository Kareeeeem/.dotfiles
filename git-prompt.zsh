# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
    (git symbolic-ref -q HEAD || git name-rev --name-only \
        --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {
    if [[ -n $(git status --porcelain 2> /dev/null) ]]; then
        echo "%F{red}"
    else
        echo "%F{green}"

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
