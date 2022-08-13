#!/usr/bin/env bash

__BUTILS_DIRNAME=$(dirname "${BASH_SOURCE[0]}")
__BUTILS_ALL=( check_positional has_equals split_at_equals check_no_default_param check_param )
source "${__BUTILS_DIRNAME}/import.sh" save "${BASH_SOURCE[0]}" "${__BUTILS_ALL[@]}"

set +x
set -euo pipefail


check_positional() {
    FLAG="${1}"
    VALUE="${2}"
    if [ -z "${VALUE:-}" ]
    then
        echo "ERROR: Positional argument ${FLAG} is missing." 1>&2
        exit 1
    fi
    true
}

has_equals() {
    return $([[ "${1}" = *"="* ]])
}

split_at_equals() {
    IFS="=" FLAG=( ${1} )
    ONE="${FLAG[0]}"
    TWO=$(printf "=%s" "${FLAG[@]:1}")
    IFS="=" echo "${ONE}" "${TWO:1}"
}

check_no_default_param() {
    FLAG="${1}"
    PARAM="${2}"
    VALUE="${3}"
    [ ! -z "${PARAM:-}" ] && (echo "ERROR: Argument ${FLAG} supplied multiple times" 1>&2; exit 1)
    [ -z "${VALUE:-}" ] && (echo "ERROR: Argument ${FLAG} requires a value" 1>&2; exit 1)
    true
}

check_param() {
    FLAG="${1}"
    VALUE="${2}"
    [ -z "${VALUE:-}" ] && (echo "ERROR: Argument ${FLAG} requires a value" 1>&2; exit 1)
    true
}


source "${__BUTILS_DIRNAME}/import.sh" restore "${BASH_SOURCE[0]}" "${@:-}" -- "${__BUTILS_ALL[@]:-}"
unset __BUTILS_ALL
unset __BUTILS_DIRNAME
