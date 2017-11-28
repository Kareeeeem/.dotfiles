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

# colored manpages with max width 80
export MANWIDTH=80

# no duplicates or lines starting with space
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000000
HISTFILESIZE=1000000

shopt -s histappend   # append to history file, don't overwrite it
shopt -s checkwinsize # update the values of LINES and COLUMNS.
shopt -s globstar     # ** matches all files and 0 or more (sub)directories
shopt -s autocd       # cd without typing cd
shopt -s cmdhist      # save multiline commands as one
shopt -s extglob

stty -ixon            # Disable START/STOP signals

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
    if [ -d $HOME/.bash_completion.d ]; then
        for f in $HOME/.bash_completion.d/* ; do
            . $f
        done
    fi
fi

if [ -d $HOME/.dotfiles ]; then
    . $HOME/.dotfiles/prompt.sh
    . $HOME/.dotfiles/autoenv.sh
    . $HOME/.dotfiles/z/z.sh
    . $HOME/.dotfiles/bash_functions
    . $HOME/.dotfiles/bash_aliases
fi

[ -f ~/.fzf.bash ] && . ~/.fzf.bash
