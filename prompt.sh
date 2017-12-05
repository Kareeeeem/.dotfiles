#!/usr/bin/env bash

_autoenv_prompt() {
    if [[ -n $AUTOENV ]]; then
        echo -n "${AUTOENV_PROMPT:-env} "
    fi
}

# show last status if not 0. http://stackoverflow.com/a/16715681
_status_prompt() {
    local EXIT=$?
    if [[ $EXIT != 0 ]]; then
        echo -n "$EXIT "
    fi
}

export GIT_PS1_STATESEPARATOR=""
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export PROMPT_COMMAND="_prompt_command"
_prompt_command() {
    # Save the status before anything else so $? does not get overwritten.
    local _status=$(_status_prompt) pwd

    _autoenv

    _pwd=$(awk '
        BEGIN { FS="/" }
        NF <= 2 { printf "%s", $0 }
        NF > 2 { p=sprintf("%s/%s", $(NF-1), $NF); gsub(/.*kareem/, "~", p); printf "%s", p }
    ' <<< $PWD )

    __git_ps1 "$_status\[\e[2m\]$(_autoenv_prompt)" "\[\e[0m\]${_pwd} $ " "%s "

    history -a  # Append new lines to history file
    history -c  # Clear the history list
    history -r  # Append the history file to the history list

    # Set the window title to the $PWD
    echo -ne "\033]0;$PWD\007"
}
