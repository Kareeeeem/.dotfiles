#!/usr/bin/env bash

# Auto activates environments by sourcing .env files. Env files are
# authenticated by checking a checksum.  If envfile provides a function
# _deactivate calling _deactivate_env or the alias deac will call it.

AUTOENV_ENVFILE=.env
AUTOENV_CHECKSUM=.envsum
AUTOENV_LAST_PWD=
export AUTOENV=


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

_deactivate_environment () {
	AUTOENV=
	unalias deac
	# If the envfile defined _deactivate call it.
	declare -f _deactivate > /dev/null 2>&1 && _deactivate
}

_autoenv () {
	[ "$AUTOENV_LAST_PWD" = "$PWD" ] && return
	AUTOENV_LAST_PWD=$PWD

	[ -n "$AUTOENV" ] && return
	! _file_exists "$AUTOENV_ENVFILE" && return

	if _envfile_is_authorized || _confirm_envfile; then
		_authorize_envfile
		AUTOENV="$PWD/$AUTOENV_ENVFILE"
		. "$AUTOENV_ENVFILE"
		alias deac="_deactivate_environment"
	fi
}

showenv () {
	if [ -n "$AUTOENV" ] && _file_exists "$AUTOENV"; then
		cat "$AUTOENV"
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

grep --quiet _autoenv <<< "$PROMPT_COMMAND" || \
	PROMPT_COMMAND="_autoenv; $PROMPT_COMMAND"
