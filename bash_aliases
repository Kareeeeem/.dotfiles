#!/usr/bin/bash

alias rmpyc='find . -name "*.pyc" -delete'
alias rmswp='rm -f $HOME/.vim/tmp/*sw*'

alias evim='vim $HOME/.vimrc'
alias ebash='vim $HOME/.bashrc $HOME/.profile $HOME/.bash_aliases'

alias sourceb='. $HOME/.bashrc'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias b='cd -'
alias p='pushd'
alias pp='popd'
alias dirs='dirs -v'

alias la='ls -a'
alias l='ls -lAhF --group-directories-first'
#	        ├l long listing
#	        ├─A hidden files (ignore . and ..)
#	        ├──h human readable sizes
#	        └───F classifiers

alias json='python -m json.tool'

alias t='tmux'
alias ta='tmux a'
alias tk='tmux kill-session'
alias tl='tmux ls'
