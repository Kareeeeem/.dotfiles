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

# Colors
export BLACK='\[\e[0;30m\]';
export BLUE='\[\e[0;34m\]';
export GREEN='\[\e[0;32m\]';
export CYAN='\[\e[0;36m\]';
export RED='\[\e[0;31m\]';
export PURPLE='\[\e[0;35m\]';
export BROWN='\[\e[0;33m\]';
export LIGHTGRAY='\[\e[0;37m\]';
export DARKGRAY='\[\e[1;30mm\]';
export LIGHTBLUE='\[\e[1;34m\]';
export LIGHTGREEN='\[\e[1;32m\]';
export LIGHTCYAN='\[\e[1;36m\]';
export LIGHTRED='\[\e[1;31m\]';
export LIGHTPURPLE='\[\e[1;35m\]';
export YELLOW='\[\e[1;33m\]';
export WHITE='\[\e[1;37m\]';
export RESETC='\[\e[0m\]'

HISTCONTROL=ignoreboth # no duplicates or lines starting with space
HISTSIZE="NOTHING" # no limit
HISTFILESIZE="NOTHING" # no limit

shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize # update the values of LINES and COLUMNS.
shopt -s globstar # match all files and zero or more (sub)directories
shopt -s autocd # ch without typing ch

# PROMPT STUFF
_virtualenv_prompt() {
	if [ -n "$VIRTUAL_ENV" ]; then
		echo "$LIGHTPURPLE$(basename "$VIRTUAL_ENV")$RESETC "
	fi
}

_dir_prompt() {
	echo "$(basename "$(dirname "$PWD")")/$(basename "$PWD")"
}

# http://stackoverflow.com/a/16715681
_status_prompt() {
	local EXIT="$?"
	if [ $EXIT != 0 ]; then
		echo "${RED}$EXIT${RESETC} "
	fi
}

_git_prompt() {
	local branch
	local state
	local stashes
	ref=$(git symbolic-ref -q HEAD 2> /dev/null || \
		git name-rev --name-only --no-undefined --always HEAD 2> /dev/null)
	if [ -n "$ref" ]; then
		branch=${ref#refs/heads/}
		if [[ -n $(git status --porcelain 2> /dev/null) ]]; then
			state=$LIGHTRED
		else
			state=$LIGHTGREEN
		fi
		st_num=$(git stash list 2> /dev/null | wc -l | tr -d ' ')
		if [[ $st_num != "0" ]]; then
			stashes="$RED($st_num)$RESETC"
		fi
		echo " $state$branch$RESETC$stashes"
	fi

}

prompt_command() {
	# Do this in a prompt command to allow color codes in functions.
	PS1="$(_status_prompt)$(_virtualenv_prompt)$(_dir_prompt)$(_git_prompt) % "
}

export PROMPT_COMMAND="prompt_command"

# Disable START/STOP signals
stty -ixon

# FZF
[ -f ~/.fzf.bash ] && . ~/.fzf.bash
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_OPTS='--color=bw'

# GIT Completion
. "/home/kareem/.dotfiles/git-completion.bash"

# Z
. "/home/kareem/sources/z/z.sh"

# TMUX completion
. "/home/kareem/.dotfiles/tmux.completion.bash"

# mkdir and cd to it. http://unix.stackexchange.com/a/9124
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
		LESS_TERMCAP_so="$(printf "\e[1;44;33m")" \
		LESS_TERMCAP_ue="$(printf "\e[0m")" \
		LESS_TERMCAP_us="$(printf "\e[1;32m")" \
			man "$@"
}

. ~/.bash_aliases
