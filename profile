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
[ -d "$HOME/bin" ]  && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ]  && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.local/racket/bin" ]  && PATH="$HOME/.local/racket/bin:$PATH"
[ -d "$HOME/.gem/ruby/2.5.0/bin" ] && PATH="$HOME/.gem/ruby/2.5.0/bin:$PATH"

hash rg && export FZF_DEFAULT_COMMAND='rg --files --hidden'
hash vim && export VISUAL="vim" && export EDITOR="$VISUAL"
hash st && export TERMINAL=st
export FZF_DEFAULT_OPTS='--no-bold --color=bw'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# https://www.gnu.org/software/coreutils/manual/html_node/Formatting-the-file-names.html
# https://unix.stackexchange.com/q/258679
export QUOTING_STYLE=literal
export TERMINAL=st
export KEYBASE_SYSTEMD=1

export GOROOT=$HOME/.local/go
PATH=$PATH:$GOROOT/bin

# PATH=$HOME/.pyenv/bin:$PATH

export PATH

if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]; then
    exec startx
fi
