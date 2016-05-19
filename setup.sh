#! /usr/bin/env sh

# Setup a debian chroot on my chromebook with (almost) everything I want.
# might have run twice for all the installs to work.

set -e

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y \
    vim-nox \
	cmake \
	python-dev \
	python3-dev \
	postgresql \
    libffi-dev \
	git \
	man \
	curl \
	zsh \
	openssh-server \
	tmux \
	wget \
	exuberant-ctags \
	silversearcher-ag \
	par

echo "enter your email (for ssh key generation and git), followed by [ENTER]."
read EMAIL

ssh-keygen -t rsa -b 4096 -C "$EMAIL"

cat "$HOME/.ssh/id_rsa.pub"

# Prompt user to add key to github account. So we can clone with ssh.
read -p "Add key to github account and then press enter." reply

git config --global user.email "$EMAIL"
git config --global user.name "Mohammed Kareem"

git clone git@github.com:rupa/z.git "$HOME/sources/z"

git clone git@github.com:Kareeeeem/.dotfiles.git "$HOME/.dotfiles"
sh "$HOME/.dotfiles/install.sh"

curl https://bootstrap.pypa.io/get-pip.py | sudo python -
pip install --user virtualenv flake8

echo "TODO"
echo "* setup locales"
echo "* recreate pg cluster with new locale"
echo "* if in chroot setup postgres and ssh server to start up in /etc/rc.local"
