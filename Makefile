# https://stackoverflow.com/a/18137056
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

.PHONY: symlinks completions bin all

all: symlinks completions bin

symlinks:
	mkdir -p $(HOME)/.config/nvim
	ln -f -s $(current_dir)/ctags $(HOME)/.ctags &> /dev/null
	ln -f -s $(current_dir)/vimrc $(HOME)/.config/nvim/init.vim &> /dev/null
	ln -f -s $(current_dir)/tmux.conf $(HOME)/.tmux.conf &> /dev/null
	ln -f -s $(current_dir)/rtorrent.rc $(HOME)/.rtorrent.rc &> /dev/null
	ln -f -s $(current_dir)/bashrc $(HOME)/.bashrc &> /dev/null
	ln -f -s $(current_dir)/bash_logout $(HOME)/.bash_logout &> /dev/null
	ln -f -s $(current_dir)/profile $(HOME)/.profile &> /dev/null
	ln -f -s $(current_dir)/inputrc $(HOME)/.inputrc &> /dev/null
	ln -f -s $(current_dir)/gitignore $(HOME)/.gitignore &> /dev/null
	ln -f -s $(current_dir)/gitconfig $(HOME)/.gitconfig &> /dev/null
	ln -f -s $(current_dir)/gitconfig-work $(HOME)/.gitconfig-work &> /dev/null
	ln -f -s $(current_dir)/rgignore $(HOME)/.rgignore &> /dev/null

completions:
	rm -rf $(HOME)/.bash_completion.d
	ln -f -s $(current_dir)/bash_completion.d $(HOME)/.bash_completion.d

bin:
	python3 -m pip install --user -U -r bin/requirements.txt
