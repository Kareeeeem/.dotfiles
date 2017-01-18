#!/usr/bin/env bash

PROMPT_BOLD='\[\e[1m\]'
PROMPT_UNDERLINE='\[\e[4m\]'
PROMPT_RESET='\[\e[0m\]'

# we're setting the prompt command so his needs to be done manually.
_virtualenv_prompt() {
	if [ -n "$VIRTUAL_ENV" ]; then
		echo -n "$PROMPT_BOLD$(basename "$VIRTUAL_ENV")$PROMPT_RESET "
	fi
}

# show last status if not 0. http://stackoverflow.com/a/16715681
_status_prompt() {
	local EXIT
	EXIT=$?
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

export PROMPT_LONG=1
# prompt toggle
pt() {
	PROMPT_LONG=$([ $PROMPT_LONG == 0 ] && echo 1 || echo 0)
}

_prompt_command() {
	if [ $PROMPT_LONG -eq 0 ]; then
		PS1="$ "
	else
		PS1=$(_status_prompt)
		PS1+=$(_chroot_prompt)
		PS1+=$(_virtualenv_prompt)
		PS1+="\W"
		PS1+=$(_git_prompt)
		PS1+=" $ "
	fi

	export PS1

	# merge history after each command
	history -a # Append new lines to history file
	history -c # Clear the history list
	history -r # Append the history file to the history list
}

export PROMPT_COMMAND="_prompt_command; "
