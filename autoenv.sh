#!/usr/bin/env bash

# Auto activates environments by sourcing .env files. Env files are
# authenticated by validating them against a checksum. If envfile provides a
# function _deactivate calling deactivating the environment will call it.

# The filename of environment files
AUTOENV_ENVFILE=.env
# Where it will store checksums
AUTOENV_CHECKSUM=~/.envsum

# Used as a heuristic to see if we want to check for environment files.
AUTOENV_LAST_PWD=

export AUTOENV_PROMPT=
export AUTOENV=

# create the checksum directory if it does not exist
[ ! -d "$AUTOENV_CHECKSUM" ] && mkdir -p "$AUTOENV_CHECKSUM"

# HELPERS
_checksum_filename () {
    echo "$AUTOENV_CHECKSUM/$(echo -n "$PWD" | md5sum | awk '{print $1}')"
}

_envfile_is_authorized () {
    checksum=$(_checksum_filename)
    [ -f "$checksum" ] && md5sum -c "$checksum" < $AUTOENV_ENVFILE > /dev/null 2>&1
}

_authorize_envfile () {
	echo "--- ENVFILE BEGIN ---"
	cat "$AUTOENV_ENVFILE"
	echo "--- ENVFILE END ---"
	read -r -n 1 -p "Authorize envfile? y/n " answer
	echo

	if [ "${answer,,}" = "y" ]; then
        md5sum < $AUTOENV_ENVFILE > "$(_checksum_filename)"
		return 0
	else
		return 1
	fi
}


# MAIN
_autoenv () {
	if [ "$AUTOENV_LAST_PWD" = "$PWD" ]; then
        return
    else
        AUTOENV_LAST_PWD=$PWD
    fi

	[ -n "$AUTOENV" ] && return

	_activate_environment
}

# (DE/RE)ACTIVATION
_deactivate_environment () {
	AUTOENV=
	AUTOENV_PROMPT=
    _deactivate > /dev/null 2>&1
    unset -f _deactivate
}

_reactivate_environment () {
	_deactivate_environment
	# Force the activation to run again upon running the prompt command.
	AUTOENV_LAST_PWD=
}

_activate_environment () {
	local slashes current_dir original_dir

	original_dir="$PWD"
	current_dir="$original_dir"
	slashes=${current_dir//[^\/]/}

    # Bubble up to $HOME to find an $AUTOENV_FILE.
	for (( n=${#slashes}; n>1; --n )); do
		if [ -f "$current_dir/$AUTOENV_ENVFILE" ]; then
			cd "$current_dir"

            if _envfile_is_authorized || _authorize_envfile; then
                AUTOENV="$PWD/$AUTOENV_ENVFILE"
                . "$AUTOENV_ENVFILE"
            fi

			cd "$original_dir"
			return
		else
			current_dir="$current_dir/.."
		fi
	done
}

# SHOWING AND EDITING CURRENT ENV
_showenv () {
	if [ -f "$AUTOENV" ]; then
		cat "$AUTOENV"
		echo "$AUTOENV"
	else
		echo "No environment sourced or envfile has been moved or deleted."
	fi
}

_editenv () {
	if [ -f "$AUTOENV" ]; then
		$EDITOR "$AUTOENV"
	else
		echo "No environment sourced or envfile has been moved or deleted."
	fi
}

# Set up the prompt command and entrypoint
if [ -z "$_AUTOENV_NO_PROMPT_COMMAND" ]; then
	grep --quiet _autoenv <<< "$PROMPT_COMMAND" || \
		PROMPT_COMMAND="_autoenv; $PROMPT_COMMAND"
fi

e () {
    case $1 in
        "ac") _activate_environment ;;
        "de") _deactivate_environment ;;
        "re") _deactivate_environment && _activate_environment ;;
        "show") _showenv ;;
        "edit") _editenv ;;
        *) echo "[USAGE] e ac|de|re" ;;
    esac
}
