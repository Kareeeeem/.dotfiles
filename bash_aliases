#!/usr/bin/bash

alias rmpyc='find . -name "*.pyc" -delete'
alias rmswp='rm -f $HOME/.vim/tmp/*sw*'

alias evim='vim $HOME/.dotfiles/vimrc'
alias ebash='vim $HOME/.dotfiles/{bashrc,profile,bash_aliases,bash_prompt,bash_functions}'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias b='cd -'
alias p='pushd'
alias pp='popd'
alias dirs='dirs -v'

alias l='ls -lhF --group-directories-first'
#	        ├l long listing
#	        ├─h human readable sizes
#	        └──F classifiers
alias la='l -A' # A Hidden files, ignore . and ..

alias json='python -m json.tool'

alias t='tmux'
alias tk='tmux kill-session'
alias tl='tmux ls'

# http://askubuntu.com/a/17279
alias pcp="rsync -ah --progress"
#				 ├a equals -rlptgoD.
#				 │		  ├recursive
#				 │		  ├─copy symlinks,
#				 │		  ├──preserve permissions
#				 │		  ├───preserve modification times
#				 │		  ├────preserve group
#				 │		  ├─────preserve owner (superuser only)
#				 │		  └──────preserve device files and special files.
#				 └─h human readable numbers
