#!/usr/bin/sh
set global tabstop     4
set global indentwidth 4
set global scrolloff 1,5

set global makecmd 'make --jobs=8'
set global grepcmd 'ag --column'
colorscheme lucius

source "$HOME/.config/kak/flake8.kak"

hook global WinCreate .* %{addhl number_lines}
hook global WinSetOption filetype=python %{
	flake8-enable-diagnostics
    jedi-enable-autocomplete
    %sh{
        if [ -z $VIRTUAL_ENV ]; then
            echo 'set buffer jedi_python_path "$VIRTUALENV/bin/python"'
        fi
    }
}

def -docstring 'invoke fzf to open a file' \
	fzf-file %{ %sh{
		FILE=$(find * -type f ! -path "*venv/*" ! -path "*node_modules/*" ! -path "*.pyc"  | fzf-tmux)
		if [ -n "$FILE" ]; then
			echo "eval -client '$kak_client' 'edit ${FILE}'" | kak -p ${kak_session}
		fi
	}}

def -docstring 'invoke fzf to open buffer' \
	fzf-buffer %{ %sh{
		BUFFER=$(echo ${kak_buflist} | tr : '\n' | fzf-tmux)
		if [ -n "$BUFFER" ]; then
			echo "eval -client '$kak_client' 'buffer $BUFFER'" | kak -p ${kak_session}
		fi
	}}

map global user f :fzf-file<ret>
map global user b :fzf-buffer<ret>
map global user n :flake8-parse<ret>

