# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# no duplicates or lines starting with space
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=100000
HISTFILESIZE=100000

shopt -s histappend		# append to history file, don't overwrite it
shopt -s checkwinsize	# update the values of LINES and COLUMNS.
shopt -s globstar		# ** matches all files and 0 or more (sub)directories
shopt -s autocd			# cd without typing cd
shopt -s cmdhist		# save multiline commands as one
shopt -s cdable_vars	# cd to directories in variables
stty -ixon				# Disable START/STOP signals

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# PROMPT STUFF

# Colors
PROMPT_BOLD='\e[1m'
PROMPT_UNDERLINE='\e[4;1m'
PROMPT_RESET='\e[0m'

# we're setting the prompt command so his needs to be done manually.
_virtualenv_prompt() {
	if [ -n "$VIRTUAL_ENV" ]; then
		echo "$PROMPT_BOLD$(basename "$VIRTUAL_ENV")$PROMPT_RESET "
	fi
}

# show last status if not 0. http://stackoverflow.com/a/16715681
_status_prompt() {
	local EXIT="$?"
	if [ $EXIT != 0 ]; then
		echo "$PROMPT_BOLD$EXIT$PROMPT_RESET "
	fi
}

# show branch and it's state in green/red, and number of stashes.
_git_prompt() {
	local branch
	local state
	local stashes
	ref=$(git symbolic-ref -q HEAD 2> /dev/null || \
		git name-rev --name-only --no-undefined --always HEAD 2> /dev/null)
	if [ -n "$ref" ]; then
		branch=${ref#refs/heads/}
		if [[ -n $(git status --porcelain 2> /dev/null) ]]; then
			state=$PROMPT_UNDERLINE
		else
			state=$PROMPT_BOLD
		fi
		st_num=$(git stash list 2> /dev/null | wc -l | tr -d ' ')
		if [[ $st_num != "0" ]]; then
			stashes="$PROMPT_BOLD($st_num)$PROMPT_RESET"
		fi
		echo " $state$branch$PROMPT_RESET$stashes"
	fi
}

_chroot_prompt() {
	if [ -n "$debian_chroot" ]; then
		echo "($debian_chroot) "
	fi
}

# Set PS1 in a prompt command to allow color codes in functions.
_prompt_command() {
	PS1="$(_status_prompt)$(_chroot_prompt)$(_virtualenv_prompt)\W$(_git_prompt) % "

	# merge history after each command
	history -a # Append new lines to history file
	history -c # Clear the history list
	history -r # Append the history file to the history list
}

export PROMPT_COMMAND="_prompt_command"

# mkdir and cd. http://unix.stackexchange.com/a/9124
mkcd () {
	case "$1" in
		*/..|*/../) cd -- "$1" ;; # that doesn't make any sense unless the directory already exists
		/*/../*) (cd "${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd -- "$1" ;;
		/*) mkdir -p "$2" && cd "$1" ;;
		*/../*) (cd "./${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd "./$1" ;;
		../*) (cd .. && mkdir -p "${1#.}") && cd "$1" ;;
		*) mkdir -p "./$1" && cd "./$1" ;;
	esac
}

# colored manpages with max width 80
export MANWIDTH=80
man() {
	env \
		LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
		LESS_TERMCAP_md="$(printf "\e[1;31m")" \
		LESS_TERMCAP_me="$(printf "\e[0m")" \
		LESS_TERMCAP_se="$(printf "\e[0m")" \
		LESS_TERMCAP_so="$(printf "\e[7m")" \
		LESS_TERMCAP_ue="$(printf "\e[0m")" \
		LESS_TERMCAP_us="$(printf "\e[1;32m")" \
			man "$@"
}

# Z https://github.com/rupa/z
[ -d "$HOME/sources/z" ] && . "$HOME/sources/z/z.sh"
# GIT Completion https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
[ -f "$HOME/.dotfiles/git-completion.bash" ] && . "$HOME/.dotfiles/git-completion.bash"
# TMUX complation https://github.com/imomaliev/tmux-bash-completion
[ -f "$HOME/.dotfiles/tmux.completion.bash" ] && . "$HOME/.dotfiles/tmux.completion.bash"

# FZF
if hash ag; then
	export FZF_DEFAULT_COMMAND='ag -g ""'
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
export FZF_DEFAULT_OPTS='--no-bold --color=bw'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Open files in .viminfo
v() {
	local files
	files=$(grep '^>' ~/.viminfo | cut -c3- |
	while read -r line; do
		[ -f "${line/\~/$HOME}" ] && echo "$line"
	done | fzf-tmux -d -m -q "$*" -1) && vim ${files//\~/$HOME}
}

# intergration with z
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf-tmux +s --tac --query "$*" | sed 's/^[0-9,.]* *//')"
}

. ~/.bash_aliases
