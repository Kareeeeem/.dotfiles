#!/usr/bin/env bash

# Serve a directory.
# option -p: port (not required)
serve() {
	local port
	if [ "$1" = "-p" ]; then
		port="$2"
		shift 2
	fi

    IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')

    # This makes it easier to open the link.
    echo Will serve HTTP on http://$IP:${port:-8000} ...
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

_get_hotpluggable_devices () {
    lsblk --output HOTPLUG,TYPE,NAME,MODEL,MAJ:MIN,MOUNTPOINT --path --raw | \
    awk -F '[ ]' '
        $1 != 1 { next }
        $2 == "disk" {
            gsub(/\\x20/,"",$4)
            name=tolower($4);
        }
            $2 == "part" && $6 == "" {
            sub(":","",$5);
            mntpnt="/media/"name$5;
            printf "%s %s\n", $3, mntpnt
        }'
}

vrg () {
    vim -q <(rg "$1" --vimgrep)
}
