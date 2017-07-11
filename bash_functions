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
    echo Will serve HTTP on http://0.0.0.0:8000 ...
	(cd "${1:-$PWD}" && python2 -m SimpleHTTPServer "${port:-8000}" > /dev/null)
}

mkcd () {
	mkdir -p "./$1" && cd "./$1" || exit
}

pyclean () {
    find . -name *.pyc -type f -delete
    find . -name __pycache__ -type d -exec rm -rf {} +
}

mnt () {
    drive="$(ls -l /dev/disk/by-label \
        | awk 'NF > 8 {printf "%s %s\n", $9, $11}' \
        | fzf-tmux)"
    pmount "/dev/disk/by-label/${drive%% *}" "/media/${drive%% *}" && \
        notify-send "Drive mounted" "/dev/${drive##*/} mounted on /media/${drive%% *}"
}

umnt () {
    drive="$(ls -l /media \
        | awk 'NF > 8 {print $9}' \
        | fzf-tmux)"
    pumount "/dev/disk/by-label/$drive" && \
        notify-send "Drive unmounted" "media/$drive unmounted"
}
