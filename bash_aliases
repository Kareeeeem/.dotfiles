alias rp='find . -name "*.pyc" -delete'
alias rs='rm ~/.vim/tmp/*sw*'

alias vi='vim'

alias evim='vim $HOME/.vimrc'
alias ebash='vim $HOME/.bashrc $HOME/.profile $HOME/.bash_aliases'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias b='cd -'
alias p='pushd'
alias pp='popd'
alias dirs='dirs -v'

# ls options
#	l long listing
#	a hidden files
#	h human readable sizes
#	F classifiers
#	t sort by modification time
alias l='ls -lahFt --group-directories-first'
alias la='ls -a'

alias json='python -m json.tool'
alias serve='python -m SimpleHTTPServer'

alias t='tmux'
alias ta='tmux a'
alias tat='tmux a -t'
alias tk='tmux kill-session'
alias ts='tmux new-session -s'
alias tl='tmux ls'
