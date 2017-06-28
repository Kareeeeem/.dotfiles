#!/usr/bin/env bash

# Auto activates environments by sourcing .env files. Env files are
# authenticated by validating them against a checksum.  If envfile provides a
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
    md5sum < $AUTOENV_ENVFILE > "$(_checksum_filename)"
}

_confirm_envfile () {
	echo "--- ENVFILE BEGIN ---"
	cat "$AUTOENV_ENVFILE"
	echo "--- ENVFILE END ---"
	read -r -n 1 -p "Authorize envfile? y/n " answer
	echo

	if [ "${answer,,}" = "y" ]; then
		return 0
	else
		return 1
	fi
}


# MAIN
_autoenv () {
	[ "$AUTOENV_LAST_PWD" = "$PWD" ] && return
	AUTOENV_LAST_PWD=$PWD

	[ -n "$AUTOENV" ] && return

	_activate_environment
}

# (DE/RE)ACTIVATION

_deactivate_environment () {
	AUTOENV=
	AUTOENV_PROMPT=
    _deactivate;
    unset -f _deactivate
}

_reactivate_environment () {
	_deactivate_environment
	# This forces _autoenv to run again
	AUTOENV_LAST_PWD=
}

_activate_environment () {
	local slashes current_dir original_dir

	original_dir="$PWD"
	current_dir="$original_dir"
	slashes=${current_dir//[^\/]/}

    # Bubble up the PWD to find an .env file
	for (( n=${#slashes}; n>1; --n )); do
		if [ -f "$current_dir/$AUTOENV_ENVFILE" ]; then
			cd "$current_dir"

            if _envfile_is_authorized || _confirm_envfile; then
                if _authorize_envfile; then
                    AUTOENV="$PWD/$AUTOENV_ENVFILE"
                    . "$AUTOENV_ENVFILE"
                fi
            fi

			cd "$original_dir"
			return
		else
			current_dir="$current_dir/.."
		fi
	done
}

# utils
# -----------------------------------------------------------------------------

_showenv () {
	if [ -n "$AUTOENV" -a -f "$AUTOENV" ]; then
		cat "$AUTOENV"
		echo "$AUTOENV"
	else
		echo "No environment sourced or envfile has been moved or deleted."
	fi
}

_editenv () {
	if [ -n "$AUTOENV" -a -f "$AUTOENV" ]; then
		$EDITOR "$AUTOENV"
	else
		echo "No environment sourced or envfile has been moved or deleted."
	fi
}

# Set up the prompt command and entrypoint
# -----------------------------------------------------------------------------

if [ -z "$_AUTOENV_NO_PROMPT_COMMAND" ]; then
	grep --quiet _autoenv <<< "$PROMPT_COMMAND" || \
		PROMPT_COMMAND="_autoenv; $PROMPT_COMMAND"
fi

if [ -z "$_AUTOENV_NO_ALIASES" ]; then
	alias deac="_deactivate_environment"
	alias reac="_reactivate_environment"
	alias ac="_activate_environment"
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
