#!/usr/bin/sh
source "$HOME/.config/kak/flake8.kak"
set global tabstop 4
set global indentwidth 4
set global scrolloff 1,5
set global makecmd 'make --jobs=8'
set global grepcmd 'ag --column'
colorscheme zenburn

# I'm only ignoring these because a hook will remove these
set global flake8_options 'W291,W293'

def -docstring 'Invoke fzf to open a file.' \
	fzf-file %{ %sh{
		if [ -z "$TMUX" ]; then
            echo 'echo -color Error Only works in tmux'
		else
			FILE=$(find * -type f ! -path "*venv/*" ! -path "*node_modules/*" ! -path "*.pyc"  | fzf-tmux)
			if [ -n "$FILE" ]; then
				echo "eval -client '$kak_client' 'edit ${FILE}'" | kak -p ${kak_session}
			fi
		fi
	}}

def -docstring 'Invoke fzf to open buffer.' \
	fzf-buffer %{ %sh{
		if [ -z "$TMUX" ]; then
            echo 'echo -color Error Only works in tmux'
		else
			BUFFER=$(echo ${kak_buflist} | tr : '\n' | fzf-tmux)
			if [ -n "$BUFFER" ]; then
				echo "eval -client '$kak_client' 'buffer $BUFFER'" | kak -p ${kak_session}
			fi
		fi
	}}

def -docstring 'Remove trailing whitespace.' rmtrail %{
	exec -draft '%s[ \t]+$<ret>d'
}

hook global BufWritePost .* %{ rmtrail }
hook global WinCreate .* %{ addhl number_lines }

hook global WinSetOption filetype=python %{
	jedi-enable-autocomplete
	flake8-enable-diagnostics
	map window normal <c-l> :flake8-lint<ret>
    # hook window -group flake8-diagnostics InsertEnd .* %{ flake8-lint }
}

map global user f :fzf-file<ret>
map global user b :fzf-buffer<ret>
