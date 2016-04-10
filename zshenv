typeset -U path

export GOROOT=$HOME/.local/bin/go
export FZF_DEFAULT_COMMAND='ag -g ""'
export GOPATH=$HOME/projects/go

path=($HOME/clones/neovim/bin $HOME/.npm/bin $GOROOT/bin ~/bin ~/.local/bin $path)
