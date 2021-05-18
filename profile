# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export PATH

# Bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
[ -d "$HOME/.dotfiles/bin" ]  && PATH="$HOME/.dotfiles/bin:$PATH"
[ -d "$HOME/.local/bin" ]  && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.npm/bin" ] && PATH="$HOME/.npm/bin:$PATH"

[ -f $HOME/.fzf.bash ] && . $HOME/.fzf.bash

if [ $(uname) == Darwin ]; then
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    # prefer the coreutils versions of commands like ls
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi

hash rg && export FZF_DEFAULT_COMMAND='rg --files --hidden'
hash nvim && export VISUAL="nvim" && export EDITOR="$VISUAL"

export FZF_DEFAULT_OPTS='--no-bold --color=bw'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export CLICOLOR=1
# https://www.gnu.org/software/coreutils/manual/html_node/Formatting-the-file-names.html
# https://unix.stackexchange.com/q/258679
export QUOTING_STYLE=literal
