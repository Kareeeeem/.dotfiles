#!/usr/bin/env bash

# Open files in .viminfo with fzf
v() {
	# If arguments are given give them to vim. Otherwise use fzf.
	[ $# -gt 0 ] && vim "$*" && return

	local files
	files=$(grep '^>' ~/.viminfo | cut -c3- |
	while read -r line; do
		[ -f "${line/\~/$HOME}" ] && echo "$line"
	done | fzf-tmux -d -m -q "$*" -1) && vim ${files//\~/$HOME}
}

# Fzf intergration with z
unalias z 2> /dev/null
z() {
	# If arguments are given give them to z. Otherwise use fzf.
	[ $# -gt 0 ] && _z "$*" && return
	cd "$(_z -l 2>&1 | fzf-tmux +s --tac --query "$*" | sed 's/^[0-9,.]* *//')" || exit
}

# select a tmux session with fzf
_tmux_session_fzf() {
	tmux ls | grep -o "^[^:]*" | fzf-tmux --tac +s
}

# wrapper around attch and switch-client
# param: client-name. Can be prefix. (required)
_tmux_attach() {
	if [ -z $TMUX ]; then
		tmux attach -t "$1"*
	else
		tmux switch-client -t "$1"*
	fi
}

# tmux attach to session/create new session/pick session with fzf.
# param: target (not required)
t() {
	local target
	if [ -n "$1" ]; then
		_tmux_attach "$1" 2> /dev/null && return
		target="$1"
		tmux new-session -d -s "$target"
	else
		target="$(_tmux_session_fzf)"
	fi
	_tmux_attach "$target"
}

# Serve a directory.
# param: dir (not required)
# option -p: port (not required)
serve() {
	local dir port
	if [ "$1" = "-p" ]; then
		port="$2"
		shift 2
	fi

	dir="${1:-$PWD}"

	(cd "$dir" && python -m SimpleHTTPServer "${port:=8000}")
}

mkcd () {
	mkdir -p "./$1" && cd "./$1" || exit
}
