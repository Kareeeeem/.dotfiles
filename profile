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

[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ]  && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.pyenv/bin" ] && PATH=$HOME/.pyenv/bin:$PATH
[ -d "/usr/local/opt/coreutils/libexec/gnubin" ] && PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
[ -d "/Users/kareem/Library/Python/3.7/bin" ] && PATH="/Users/kareem/Library/Python/3.7/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

export PATH

hash rg && export FZF_DEFAULT_COMMAND='rg --files --hidden'
hash vim && export VISUAL="vim" && export EDITOR="$VISUAL"
export FZF_DEFAULT_OPTS='--no-bold --color=bw'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# https://www.gnu.org/software/coreutils/manual/html_node/Formatting-the-file-names.html
# https://unix.stackexchange.com/q/258679
export QUOTING_STYLE=literal
export CLICOLOR=1
# export LSCOLORS=ExFxBxDxCxegedabagacad
