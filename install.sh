#! /usr/bin/env sh

dotfiles="$HOME/.dotfiles"

ln -s "$dotfiles/ctags" "$HOME/.ctags"
ln -s "$dotfiles/vimrc" "$HOME/.vimrc"
ln -s "$dotfiles/tmux.conf" "$HOME/.tmux.conf"
ln -s "$dotfiles/rtorrent.rc" "$HOME/.rtorrent.rc"
ln -s "$dotfiles/zshenv" "$HOME/.zshenv"
ln -s "$dotfiles/zshrc" "$HOME/.zshrc"
ln -s "$dotfiles/zshrc.local" "$HOME/.zshrc.local"
ln -s "$dotfiles/zsh" "$HOME/.zsh"
ln -s "$dotfiles/aliases" "$HOME/.aliases"
ln -s "$dotfiles/npmrc" "$HOME/.npmrc"
