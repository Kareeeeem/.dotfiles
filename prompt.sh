#!/usr/bin/env bash

_autoenv_prompt() {
    if [[ -n $AUTOENV ]]; then
        echo -n "\[\e[94m\]${AUTOENV_PROMPT:-env}\[\e[0m\] "
    fi
}

# show last status if not 0. http://stackoverflow.com/a/16715681
_status_prompt() {
    local EXIT=$?
    if [[ $EXIT != 0 ]]; then
        echo -n "\[\e[91m\]$EXIT\[\e[0m\] "
    fi
}

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export PROMPT_COMMAND="_prompt_command"
_prompt_command() {
    # Save the status prompt before anything else so $? does not get
    # overwritten.
    local status=$(_status_prompt)
    _autoenv
    __git_ps1 "$status$(_autoenv_prompt)" "\W $ " "\[\e[37m\]%s\[\e[0m\] "

    history -a # Append new lines to history file
    history -c # Clear the history list
    history -r # Append the history file to the history list

    # set the window title to the $PWD
    echo -ne "\033]0;$PWD\007"
}
