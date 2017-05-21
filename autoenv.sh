#!/usr/bin/env bash

# Auto activates environments by sourcing .env files. Env files are
# authenticated by checking a checksum.  If envfile provides a function
# _deactivate calling _deactivate_env or the alias deac will call it.

AUTOENV_ENVFILE=.env
AUTOENV_CHECKSUM=.envsum
AUTOENV_LAST_PWD=
export AUTOENV_PROMPT=
export AUTOENV=

# Helpers
# -----------------------------------------------------------------------------

_file_exists () {
	stat -t "$1" > /dev/null 2>&1
}

_envfile_is_authorized () {
	_file_exists "$AUTOENV_CHECKSUM" && \
		md5sum -c "$AUTOENV_CHECKSUM" > /dev/null 2>&1
}

_authorize_envfile () {
	md5sum "$AUTOENV_ENVFILE" > "$AUTOENV_CHECKSUM"
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


# "main" function
# -----------------------------------------------------------------------------

_autoenv () {
	[ "$AUTOENV_LAST_PWD" = "$PWD" ] && return
	AUTOENV_LAST_PWD=$PWD

	[ -n "$AUTOENV" ] && return
	! _file_exists "$AUTOENV_ENVFILE" && return

	_activate
}

# (de)activation
# -----------------------------------------------------------------------------

_activate_environment () {
	if _envfile_is_authorized || _confirm_envfile; then
		_authorize_envfile
		AUTOENV="$PWD/$AUTOENV_ENVFILE"
		. "$AUTOENV_ENVFILE"
	fi
}

_deactivate_environment () {
	AUTOENV=
	AUTOENV_PROMPT=
	# If the envfile defined _deactivate call it.
    if [ -n "$(declare -f -F _deactivate)" ]; then
        _deactivate;
        unset -f _deactivate
    fi
}

_reactivate_environment () {
	_deactivate_environment
	# This forces _autoenv to run again
	AUTOENV_LAST_PWD=
}

# active from child directory
_activate () {
	local slashes current_dir original_dir

	original_dir="$PWD"
	current_dir="$original_dir"
	slashes=${current_dir//[^\/]/}

	for (( n=${#slashes}; n>1; --n )); do
		if _file_exists "$current_dir/$AUTOENV_ENVFILE"; then
			cd "$current_dir"

			_activate_environment

			cd "$original_dir"
			return
		else
			current_dir="$current_dir/.."
		fi
	done
}

showenv () {
	if [ -n "$AUTOENV" ] && _file_exists "$AUTOENV"; then
		cat "$AUTOENV"
		echo "$AUTOENV"
	else
		echo "No environment sourced or envfile has been moved or deleted."
	fi
}

editenv () {
	if [ -n "$AUTOENV" ] && _file_exists "$AUTOENV"; then
		$EDITOR "$AUTOENV"
	else
		echo "No environment sourced or envfile has been moved or deleted."
	fi
}

# Set up the prompt command and aliases
# -----------------------------------------------------------------------------

if [ -z "$_AUTOENV_NO_PROMPT_COMMAND" ]; then
	grep --quiet _autoenv <<< "$PROMPT_COMMAND" || \
		PROMPT_COMMAND="_autoenv; $PROMPT_COMMAND"
fi

if [ -z "$_AUTOENV_NO_ALIASES" ]; then
	alias deac="_deactivate_environment"
	alias reac="_reactivate_environment"
fi
