# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# PROMPT

__virtualenv_prompt() {
	if [ -n "$VIRTUAL_ENV" ]; then
		echo "$LIGHTPURPLE$(basename "$VIRTUAL_ENV")$RESETC "
	fi
}

__dir_prompt() {
	echo "$(basename "$(dirname "$PWD")")/$(basename "$PWD")"
}

# http://stackoverflow.com/a/16715681
__status_prompt() {
	local EXIT="$?"
	if [ $EXIT != 0 ]; then
		echo "${RED}$EXIT${RESETC} "
	fi
}

__git_prompt() {
	local branch=''
	local state=''
	local stashes=''

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
	PS1="$(__status_prompt)"
	PS1+="$(__virtualenv_prompt)"
	PS1+="$(__dir_prompt)"
	PS1+="$(__git_prompt)"
	PS1+=" % "
}

export PROMPT_COMMAND="prompt_command"

# Disable START/STOP signals
stty -ixon

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_OPTS='--color=bw'

# GIT Completion
source "/home/kareem/.dotfiles/git-completion.bash"

# Z
source "/home/kareem/sources/z/z.sh"

# Navigation http://unix.stackexchange.com/a/4291
# pushd() {
# 	if [ $# -eq 0 ]; then
# 		DIR="${HOME}"
# 	else
# 		DIR="$1"
# 	fi

# 	builtin pushd "${DIR}" > /dev/null
# 	builtin dirs
# }

# pushd_builtin() {
# 	builtin pushd > /dev/null
# 	builtin dirs
# }

# popd() {
# 	builtin popd > /dev/null
# 	builtin dirs
# }

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

shopt -s autocd
