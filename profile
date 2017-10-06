# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# Path
[ -d "$HOME/bin" ]  && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ]  && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.npm" ] && PATH="$HOME/.npm/bin:$PATH"

if [ -d "$HOME/sources/go" ]; then
    export GOROOT=$HOME/sources/go
    export GOPATH=$HOME/projects/go
    PATH=$PATH:$GOROOT/bin
fi

# FZF
if hash rg; then
	export FZF_DEFAULT_COMMAND='rg --files --hidden'
fi
export FZF_DEFAULT_OPTS='--no-bold --color=bw'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

hash vim && export VISUAL="vim"; export EDITOR="$VISUAL"
hash st && export TERMINAL=st

if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]; then
    exec startx
fi
