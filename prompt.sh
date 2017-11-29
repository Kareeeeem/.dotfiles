#!/usr/bin/env bash

_autoenv_prompt() {
    if [[ -n $AUTOENV ]]; then
        echo -n "[${AUTOENV_PROMPT:-env}] "
    fi
}

# show last status if not 0. http://stackoverflow.com/a/16715681
_status_prompt() {
    local EXIT=$?
    if [[ $EXIT != 0 ]]; then
        echo -n "\[\e[91m\]$EXIT\[\e[0m\] "
    fi
}

_PROMPT_WIDTH_THRESHOLD=60
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export PROMPT_COMMAND="_prompt_command"
_prompt_command() {
    # Save the status before anything else so $? does not get overwritten.
    local _status=$(_status_prompt) _prompt_end="$ "
    # Add a newline if the terminal width is below a $_PROMPT_WIDTH_THRESHOLD.
    if [ $COLUMNS -lt $_PROMPT_WIDTH_THRESHOLD ]; then
        _prompt_end="\n${_prompt_end}"
    fi

    _autoenv
    __git_ps1 "$_status$(_autoenv_prompt)" "\W $_prompt_end" "[%s] "

    history -a # Append new lines to history file
    history -c # Clear the history list
    history -r # Append the history file to the history list

    # Set the window title to the $PWD
    echo -ne "\033]0;$PWD\007"
}
