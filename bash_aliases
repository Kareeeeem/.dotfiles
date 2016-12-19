alias rp='find . -name "*.pyc" -delete'
alias rs='rm ~/.vim/tmp/.*sw*'

alias v='vim'
alias e='vim'

alias evimrc='vim $HOME/.vimrc'
alias ebashrc='vim $HOME/.bashrc'

alias bashrc='. $HOME/.bashrc'

alias dots='cd $HOME/.dotfiles'
alias bin='cd $HOME/bin'

if [ -n "$debian_chroot" ]; then
	alias tmux='tmux -L $debian_chroot'
fi

alias t='tmux'
alias ta='tmux a'
alias tat='tmux a -t'
alias tk='tmux kill-session'
alias ts='tmux new-session -s'
alias tl='tmux ls'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias b='cd -'

alias p='pushd'
alias pp='popd'
alias dirs='dirs -v'

alias l='ls -lahFt'
alias ll='ls -1aF'
alias la='ls -a'

alias json='python -m json.tool'
alias serve='python -m SimpleHTTPServer'
