typeset -U path

path=($HOME/sources/neovim/bin $path)
path=($HOME/.npm/bin $path)
path=($HOME/local/bin $path)
path=($HOME/bin $path)
export GOROOT=$HOME/.local/bin/go
export GOPATH=$HOME/projects/go
path=($GOROOT/bin $path)
