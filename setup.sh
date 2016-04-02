#! /usr/bin/env sh

# Setup a debian chroot on my chromebook with (almosg) everything I want.

echo "enter your email (for ssh key generation and git), followed by [ENTER]."
read EMAIL

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y \
    vim-nox build-essential cmake python-dev python3-dev postgresql \
    libffi-dev libpq-dev git man curl zsh openssh-server tmux wget \
	exuberant-ctags silversearcher-ag

ssh-keygen -t rsa -b 4096 -C "$EMAIL"
git config --global user.email "$EMAIL"
git config --global user.name "Mohammed Kareem"

git clone git@github.com:rupa/z.git "$HOME/clones/z"

git clone git@github.com:Kareeeeem/.dotfiles.git "$HOME/.dotfiles"
sh "$HOME/.dotfiles/install.sh"

curl https://bootstrap.pypa.io/get-pip.py | sudo python -
pip install --user virtualenv flake8

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir ~/.vim/tmp > /dev/null 2>&1
mkdir ~/.vim/undodir > /dev/null 2>&1

vim +PlugInstall +qall

echo "TODO"
echo "* setup locales"
echo "* recreate pg cluster with new locale"
echo "* if in chroot setup postgres and ssh server to start up in /etc/rc.local"
