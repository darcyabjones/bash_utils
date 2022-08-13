#!/usr/bin/env bash

# Note that we use these crazy variable names so that it's extremely unlikely to
# clash with anything else.

__IMPORT_IMPORT_DIRNAME="$(dirname ${BASH_SOURCE[0]})"
__IMPORT_IMPORT_SUBCOMMAND="${1}"
__IMPORT_IMPORT_FILENAME="${2}"

source "${__IMPORT_IMPORT_DIRNAME}/preserve_set.sh" save "${__IMPORT_IMPORT_FILENAME}"

set +x
set -euo pipefail

shift 2

__isin() {
    PARAM=$1
    shift
    for f in $@
    do
        if [[ "${PARAM}" == "${f}" ]]; then return 0; fi
    done

    return 1
}


if [ "${__IMPORT_IMPORT_SUBCOMMAND:-}" = "save" ]
then
    declare -A __IMPORT_SAVE_ENV
    for var in ${@}
    do
        if [ ! -z "${!var:-}" ]
        then
            __IMPORT_SAVE_ENV["${__IMPORT_IMPORT_FILENAME}.${var}"]=$(declare -p "${var}")
        elif declare -f -F "${var}" 2>&1 > /dev/null
        then
            __IMPORT_SAVE_ENV["${__IMPORT_IMPORT_FILENAME}.${var}"]=$(declare -f "${var}")
        fi
    done
elif [ "${__IMPORT_IMPORT_SUBCOMMAND:-}" = "restore" ]
then
    __IMPORT_IMPORT_IMPORTS=( )
    __IMPORT_IMPORT_ALL=( )
    __IMPORT_IMPORT_HAD_HYPHENS=false
    while [[ $# -gt 0 ]]
    do
        if [ "$1" == "--" ]
        then
            __IMPORT_IMPORT_HAD_HYPHENS=true
        elif [ "${__IMPORT_IMPORT_HAD_HYPHENS}" = "true" ]
        then
            __IMPORT_IMPORT_ALL=( "${__IMPORT_IMPORT_ALL[@]}" "$1" )
        else
            __IMPORT_IMPORT_IMPORTS=( "${__IMPORT_IMPORT_IMPORTS[@]}" "$1" )
        fi
        shift
    done

    if [ "${__IMPORT_IMPORT_IMPORTS[0]}" = "@" ]
    then
        __IMPORT_IMPORT_IMPORTS=( "${__IMPORT_IMPORT_ALL[@]}" )
    elif [ "${#__IMPORT_IMPORT_IMPORTS[@]}" -eq 0 ]
    then
        echo "ERROR: didn't get any thing to import, please use @ to import all"  1&2
        exit 1
    else
        for var in "${__IMPORT_IMPORT_IMPORTS[@]}"
        do
            if ! __isin "${var}" "${__IMPORT_IMPORT_ALL[@]}"
            then
                echo "ERROR: import ${var} is not in ${__IMPORT_IMPORT_ALL[@]}"
                exit 1
            fi
        done
    fi

    if [ "${#__IMPORT_IMPORT_IMPORTS[@]}" -gt 0 ] && [ "${#__IMPORT_IMPORT_ALL[@]}" -gt 0 ]
    then
        for var in "${__IMPORT_IMPORT_ALL[@]}"
        do
            if ! __isin "${var}" "${__IMPORT_IMPORT_IMPORTS[@]}"
            then
                unset "${var}"
            fi
        done
    fi

    if [ "${__IMPORT_IMPORT_HAD_HYPHENS}" != "true" ]
    then
        echo "ERROR: import.sh restore must take two lists separated by --." 1>&2
        echo "ERROR: If you don't want to filter, you don't have to run the command." 1>&2
        exit 1
    fi

    # Restore previous arguments if we're not keeping them all
    if declare -A -p __IMPORT_SAVE_ENV > /dev/null 2>&1
    then
        for var in ${!__IMPORT_SAVE_ENV[@]}
        do
            if [[ "${var}" != "${__IMPORT_IMPORT_FILENAME}"* ]]
            then
                # Came from another file
                continue
            elif __isin "${var#${__IMPORT_IMPORT_FILENAME}}" "${__IMPORT_IMPORT_IMPORTS[@]}"
            then
                # We want to keep it
                continue
            fi
            eval "${__IMPORT_SAVE_ENV[${var}]}"
            unset __IMPORT_SAVE_ENV[${var}]
        done

        if [ "z${__IMPORT_SAVE_ENV[@]:-}" = "z" ]
        then
            unset __IMPORT_SAVE_ENV
        fi
    fi

    unset __IMPORT_IMPORT_IMPORTS
    unset __IMPORT_IMPORT_ALL
    unset __IMPORT_IMPORT_HAD_HYPHENS

elif [ "${__IMPORT_IMPORT_SUBCOMMAND:-}" = "restoreall" ]
then
    # Restore any remaining previous arguments
    if declare -A -p __IMPORT_SAVE_ENV > /dev/null 2>&1
    then
        for var in "${!__IMPORT_SAVE_ENV[@]}"
        do
            if [[ "${var}" != "${__IMPORT_IMPORT_FILENAME}"* ]]
            then
                continue
            fi
            eval "${__IMPORT_SAVE_ENV[${var}]}"
            unset __IMPORT_SAVE_ENV[${var}]
        done

        if [ "${#__IMPORT_SAVE_ENV[@]}" -eq 0 ]
        then
            unset __IMPORT_SAVE_ENV
        fi
    fi

elif [ "${__IMPORT_IMPORT_SUBCOMMAND:-}" = "view" ]
then
    if declare -A -p __IMPORT_SAVE_ENV > /dev/null 2>&1
    then
        declare -A -p __IMPORT_SAVE_ENV
        source "${__IMPORT_IMPORT_DIRNAME}/preserve_set.sh" view "${__IMPORT_IMPORT_FILENAME}"
    fi
else
    echo "ERROR: the first argument to import.sh must be save or restore"
    exit 1
fi

unset __IMPORT_IMPORT_SUBCOMMAND
unset -f __isin

source "${__IMPORT_IMPORT_DIRNAME}/preserve_set.sh" restore "${__IMPORT_IMPORT_FILENAME}"
unset __IMPORT_IMPORT_FILENAME
unset __IMPORT_IMPORT_DIRNAME
