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

# Serve a directory.
# param: dir (not required)
# option -p: port (not required)
serve() {
	local port
	if [ "$1" = "-p" ]; then
		port="$2"
		shift 2
	fi

    # This makes it easier to open the link.
    echo Will serve HTTP on http://0.0.0.0:${port:-8000} ...
	(cd "${1:-$PWD}" && python3 -m http.server "${port:-8000}" > /dev/null)
}

mkcd () {
	mkdir -p "./$1" && cd "./$1" || exit
}

pyclean () {
    find . -name *.pyc -type f -delete
    find . -name __pycache__ -type d -delete
}

vclean () {
    find $HOME/.vim/tmp -type f -delete
}


mnt () {
    [ -z "$1" ] && return 1
    pmount "/dev/disk/by-label/$1" "/media/$1" && \
        notify-send "Drive mounted" "Mounted /media/$1"
}

_mnt () {
    local options="$(ls /dev/disk/by-label 2> /dev/null)"
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$options" -- $cur) )
}
complete -F _mnt mnt

umnt () {
    [ -z "$1" ] && return 1
    pumount "/dev/disk/by-label/$1" && \
        notify-send "Drive unmounted" "Unmounted /media/$1."
}

_umnt () {
    local options="$(ls /media 2> /dev/null)"
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$options" -- $cur) )
}
complete -F _umnt umnt
