#! /usr/bin/env bash

DOTFILES="$(git rev-parse --show-toplevel)"

ln -s "$DOTFILES/ctags" "$HOME/.ctags" > /dev/null 2>&1
ln -s "$DOTFILES/vimrc" "$HOME/.vimrc" > /dev/null 2>&1
ln -s "$DOTFILES/tmux.conf" "$HOME/.tmux.conf" > /dev/null 2>&1
ln -s "$DOTFILES/rtorrent.rc" "$HOME/.rtorrent.rc" > /dev/null 2>&1
ln -s "$DOTFILES/bashrc" "$HOME/.bashrc" > /dev/null 2>&1
ln -s "$DOTFILES/bash_logout" "$HOME/.bash_logout" > /dev/null 2>&1
ln -s "$DOTFILES/profile" "$HOME/.profile" > /dev/null 2>&1
ln -s "$DOTFILES/npmrc" "$HOME/.npmrc" > /dev/null 2>&1
ln -s "$DOTFILES/gitconfig" "$HOME/.gitconfig" > /dev/null 2>&1
ln -s "$DOTFILES/inputrc" "$HOME/.inputrc" > /dev/null 2>&1
ln -s "$DOTFILES/racketrc" "$HOME/.racketrc" > /dev/null 2>&1
ln -s "$DOTFILES/i3" "$HOME/.config/i3" > /dev/null 2>&1
ln -s "$DOTFILES/i3status" "$HOME/.config/i3status" > /dev/null 2>&1
ln -s "$DOTFILES/compton.conf" "$HOME/.config/compton.conf" > /dev/null 2>&1
ln -s "$DOTFILES/Xresources" "$HOME/.Xresources" > /dev/null 2>&1
ln -s "$DOTFILES/gitignore" "$HOME/.gitignore" > /dev/null 2>&1

sudo cp *completion.bash /etc/bash_completion.d/
