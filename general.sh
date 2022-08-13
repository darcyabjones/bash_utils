#!/usr/bin/env bash

# Note that we use these crazy variable names so that it's extremely unlikely to
# clash with anything else.

__IMPORT_GENERAL_DIRNAME=$(dirname "${BASH_SOURCE[0]}")
__IMPORT_GENERAL_ALL=( echo_stderr isin )
source "${__IMPORT_GENERAL_DIRNAME}/import.sh" save "${BASH_SOURCE[0]}" "${__IMPORT_GENERAL_ALL[@]:-}"

set +x
set -euo pipefail


echo_stderr() {
    echo $@ 1>&2
}

isin() {
    PARAM=$1
    shift
    for f in $@
    do
        if [[ "${PARAM}" == "${f}" ]]; then return 0; fi
    done

    return 1
}

source "${__IMPORT_GENERAL_DIRNAME}/import.sh" restore "${BASH_SOURCE[0]}" "${@:-}" -- "${__IMPORT_GENERAL_ALL[@]:-}"
unset __IMPORT_GENERAL_DIRNAME
unset __IMPORT_GENERAL_ALL
