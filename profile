# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.


# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export PATH
export MANPATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # --no-use  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
[ -d "$HOME/.dotfiles/bin" ]  && PATH="$HOME/.dotfiles/bin:$PATH"
[ -d "$HOME/.local/bin" ]  && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.config/npm/bin" ] && PATH="$HOME/.config/npm/bin:$PATH"


if [ $(uname) == Darwin ]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"

    # prefer the gnu utilities over mac utilities
    PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"

    PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
    MANPATH="/opt/homebrew/opt/findutils/libexec/gnuman:$MANPATH"

    PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
    MANPATH="/opt/homebrew/opt/gnu-tar/libexec/gnuman:$MANPATH"

    PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
    MANPATH="/opt/homebrew/opt/gnu-sed/libexec/gnuman:$MANPATH"

    PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
    MANPATH="/opt/homebrew/opt/grep/libexec/gnuman:$MANPATH"

    PATH="/opt/homebrew/opt/gnu-indent/libexec/gnubin/:$PATH"
    MANPATH="/opt/homebrew/opt/gnu-indent/libexec/gnuman:$MANPATH"

    PATH="/opt/homebrew/opt/gawk/libexec/gnubin/:$PATH"
    MANPATH="/opt/homebrew/opt/gawk/libexec/gnuman:$MANPATH"

    PATH="/opt/homebrew/opt/gnu-getopt/libexec/bin:$PATH"
    MANPATH="/opt/homebrew/opt/gnu-getopt/share/man:$MANPATH"

    # general homebrew paths
    PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
    MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
    INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

    # https://docs.python.org/3/library/site.html#command-line-interface
    # set after setting the homebrew path
    python3 -m site &> /dev/null && PATH="$(python3 -m site --user-base)/bin:$PATH"

fi

hash rg &> /dev/null && export FZF_DEFAULT_COMMAND='rg --files --hidden'
hash nvim &> /dev/null && export VISUAL="nvim" && export EDITOR="$VISUAL"

export FZF_DEFAULT_OPTS='--no-bold --color=bw'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export CLICOLOR=1
# https://www.gnu.org/software/coreutils/manual/html_node/Formatting-the-file-names.html
# https://unix.stackexchange.com/q/258679
export QUOTING_STYLE=literal

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
