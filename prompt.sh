#!/usr/bin/env bash

PROMPT_BOLD='\[\e[1m\]'
PROMPT_UNDERLINE='\[\e[4m\]'
PROMPT_RESET='\[\e[0m\]'

# Disable the original
export VIRTUAL_ENV_DISABLE_PROMPT=1
# we're setting the prompt command so his needs to be done manually.
_virtualenv_prompt() {
	if [ -n "$VIRTUAL_ENV" ]; then
		echo -n "$PROMPT_BOLD$(basename "$VIRTUAL_ENV")$PROMPT_RESET "
	fi
}

_autoenv_prompt() {
	if [ -n "$AUTOENV" ]; then
		echo -n "$PROMPT_BOLD""${AUTOENV_PROMPT:-env}""$PROMPT_RESET "
	fi
}

_env_prompt() {
    autoenv="$(_autoenv_prompt)"
    if [ -n "$autoenv" ]; then
		echo "$autoenv"
    else
        virtualenv="$(_virtualenv_prompt)"
        if [ -n "$virtualenv" ]; then
            echo "$virtualenv"
        fi
	fi
}

# show last status if not 0. http://stackoverflow.com/a/16715681
_status_prompt() {
	local EXIT=$?
	if [ $EXIT != 0 ]; then
		echo -n "$PROMPT_BOLD$EXIT$PROMPT_RESET "
	fi
}

# show branch (underlined if dirty), and number of stashes.
_git_prompt() {
	local prompt

	ref=$(git symbolic-ref -q HEAD 2> /dev/null || \
		git name-rev --name-only --no-undefined --always HEAD 2> /dev/null)

	if [ -n "$ref" ]; then
		if [ -n "$(git status --porcelain 2> /dev/null)" ]; then
			prompt=$PROMPT_UNDERLINE
		fi
		prompt+=$PROMPT_BOLD${ref#refs/heads/}$PROMPT_RESET

		st_num=$(git stash list 2> /dev/null | wc -l | tr -d ' ')
		if [[ $st_num != "0" ]]; then
			prompt+="$PROMPT_BOLD($st_num)$PROMPT_RESET"
		fi

		echo -n " $prompt"
	fi
}

_chroot_prompt() {
	if [ -n "$debian_chroot" ]; then
		echo -n "($debian_chroot) "
	fi
}

_prompt_command() {
	# Save the status prompt before anything else so $? does not get
	# overwritten.
	PS1="$(_status_prompt)"

	# run autoenv
	_autoenv

	PS1+=$(_chroot_prompt)
	PS1+=$(_env_prompt)
	PS1+="\W"
	PS1+=$(_git_prompt)
	PS1+=" $ "

	export PS1

	# merge history after each command
	history -a # Append new lines to history file
	history -c # Clear the history list
	history -r # Append the history file to the history list

	# set the window title to the $PWD in non tmux windows.
	# Tmux has it's own configuration.
	if [[ $TERM =~ xterm* ]]; then
		echo -ne "\033]0;$PWD\007"
	fi
}

export _AUTOENV_NO_PROMPT_COMMAND=1
export PROMPT_COMMAND="_prompt_command; "
