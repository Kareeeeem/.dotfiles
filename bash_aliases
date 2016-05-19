#! /usr/bin/env bash

alias rp='find . -name "*.pyc" -delete'
alias rs='find . -name "*.swp" -delete'
alias v='vim'
alias vimrc='vim $HOME/.vimrc'
alias bashrc='vim $HOME/.bashrc'

alias dots='cd $HOME/.dotfiles'
alias bin='cd $HOME/bin'

alias t='tmux'
alias ta='tmux a'
alias tat='tmux a -t'
alias tk='tmux kill-session'
alias ts='tmux new-session -s'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias p='pushd'
alias pp='popd'
alias d='dirs -v'

alias l='ls -lahF'
alias ll='ls -1aF'

alias json='python -m json.tool'
alias serve='python -m SimpleHTTPServer'

alias b='cd -'
