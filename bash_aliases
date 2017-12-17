#!/usr/bin/bash
alias evim='vim $HOME/.dotfiles/vimrc'
alias ebash='vim $HOME/.dotfiles/{bashrc,profile,bash_aliases,bash_prompt,bash_functions}'
alias ssh='TERM=screen-256color ssh'

alias clip="xclip -sel clip"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias la='ls -FLAH --group-directories-first' # A Hidden files, ignore . and ..
alias l='ls -lhF --group-directories-first'
#            ├l long listing
#            ├─h human readable sizes
#            └──F classifiers

alias json='python -m json.tool'

# http://askubuntu.com/a/17279
alias rcp="rsync -ah -P"
#                 ├a equals -rlptgoD.
#                 │          ├recursive
#                 │          ├─copy symlinks,
#                 │          ├──preserve permissions
#                 │          ├───preserve modification times
#                 │          ├────preserve group
#                 │          ├─────preserve owner (superuser only)
#                 │          └──────preserve device files and special files.
#                 └─h human readable numbers

alias rt="rtorrent"
