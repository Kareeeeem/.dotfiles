#! /usr/bin/env sh

dotfiles="$HOME/.dotfiles"

# mkdir "$HOME/.config/nvim" -p > /dev/null 2>&1
# mkdir "$HOME/.config/nvim/tmp" > /dev/null 2>&1
# mkdir "$HOME/.config/nvim/undodir" > /dev/null 2>&1
# mkdir "$HOME/.config/kak" > /dev/null 2>&1
#
mkdir "$HOME/.rtorrent.session" > /dev/null >2>&1

ln -s "$dotfiles/ctags" "$HOME/.ctags" > /dev/null 2>&1
ln -s "$dotfiles/vimrc" "$HOME/.vimrc" > /dev/null 2>&1
ln -s "$dotfiles/tmux.conf" "$HOME/.tmux.conf" > /dev/null 2>&1
ln -s "$dotfiles/rtorrent.rc" "$HOME/.rtorrent.rc" > /dev/null 2>&1
# ln -s "$dotfiles/zshenv" "$HOME/.zshenv" > /dev/null 2>&1
# ln -s "$dotfiles/zshrc" "$HOME/.zshrc" > /dev/null 2>&1
# ln -s "$dotfiles/zshrc.local" "$HOME/.zshrc.local" > /dev/null 2>&1
# ln -s "$dotfiles/zsh" "$HOME/.zsh" > /dev/null 2>&1
ln -s "$dotfiles/bash_aliases" "$HOME/.bash_aliases" > /dev/null 2>&1
ln -s "$dotfiles/npmrc" "$HOME/.npmrc" > /dev/null 2>&1
# ln -s "$dotfiles/ycm_extra_conf.py" "$HOME/.ycm_extra_conf.py" > /dev/null 2>&1
# ln -s "$dotfiles/init.vim" "$HOME/.config/nvim/init.vim" > /dev/null 2>&1
ln -s "$dotfiles/gitconfig" "$HOME/.gitconfig" > /dev/null 2>&1
ln -s "$dotfiles/inputrc" "$HOME/.inputrc" > /dev/null 2>&1
# ln -s "$dotfiles/kakrc" "$HOME/.config/kak/kakrc" > /dev/null 2>&1
# ln -s "$dotfiles/flake8.kak" "$HOME/.config/kak/flake8.kak" > /dev/null 2>&1
