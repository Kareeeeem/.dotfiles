typeset -U path

export GOROOT=$HOME/.local/bin/go
export GOPATH=$HOME/projects/go

path=($HOME/sources/neovim/bin $HOME/.npm/bin $GOROOT/bin ~/bin ~/.local/bin $path)
