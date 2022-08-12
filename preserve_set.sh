#!/usr/bin/env bash


if [ $# -ne 2 ]
then
    echo 'ERROR: preserve_set requires two arguments, the command (save|restore) and the script name (usually $0).' 1>&2
    exit 1
fi

if [ "${1}" = "save" ] && [ -z "${__IMPORT_ANY_SET:-}" ]
then
    declare -A __IMPORT_SAVE_SETS
    [ -o allexport ] && __IMPORT_SAVE_SETS["${2}.ALLEXPORT"]=true || __IMPORT_SAVE_SETS["${2}.ALLEXPORT"]=false
    [ -o braceexpand ] && __IMPORT_SAVE_SETS["${2}.BRACEEXPAND"]=true || __IMPORT_SAVE_SETS["${2}.BRACEEXPAND"]=false
    [ -o emacs ] && __IMPORT_SAVE_SETS["${2}.EMACS"]=true || __IMPORT_SAVE_SETS["${2}.EMACS"]=false
    [ -o errexit ] && __IMPORT_SAVE_SETS["${2}.ERREXIT"]=true || __IMPORT_SAVE_SETS["${2}.ERREXIT"]=false
    [ -o errtrace ] && __IMPORT_SAVE_SETS["${2}.ERRTRACE"]=true || __IMPORT_SAVE_SETS["${2}.ERRTRACE"]=false
    [ -o functrace ] && __IMPORT_SAVE_SETS["${2}.FUNCTRACE"]=true || __IMPORT_SAVE_SETS["${2}.FUNCTRACE"]=false
    [ -o hashall ] && __IMPORT_SAVE_SETS["${2}.HASHALL"]=true || __IMPORT_SAVE_SETS["${2}.HASHALL"]=false
    [ -o histexpand ] && __IMPORT_SAVE_SETS["${2}.HISTEXPAND"]=true || __IMPORT_SAVE_SETS["${2}.HISTEXPAND"]=false
    [ -o history ] && __IMPORT_SAVE_SETS["${2}.HISTORY"]=true || __IMPORT_SAVE_SETS["${2}.HISTORY"]=false
    [ -o ignoreeof ] && __IMPORT_SAVE_SETS["${2}.IGNOREEOF"]=true || __IMPORT_SAVE_SETS["${2}.IGNOREEOF"]=false
    [ -o keyword ] && __IMPORT_SAVE_SETS["${2}.KEYWORD"]=true || __IMPORT_SAVE_SETS["${2}.KEYWORD"]=false
    [ -o monitor ] && __IMPORT_SAVE_SETS["${2}.MONITOR"]=true || __IMPORT_SAVE_SETS["${2}.MONITOR"]=false
    [ -o noclobber ] && __IMPORT_SAVE_SETS["${2}.NOCLOBBER"]=true || __IMPORT_SAVE_SETS["${2}.NOCLOBBER"]=false
    [ -o noexec ] && __IMPORT_SAVE_SETS["${2}.NOEXEC"]=true || __IMPORT_SAVE_SETS["${2}.NOEXEC"]=false
    [ -o noglob ] && __IMPORT_SAVE_SETS["${2}.NOGLOB"]=true || __IMPORT_SAVE_SETS["${2}.NOGLOB"]=false
    [ -o nolog ] && __IMPORT_SAVE_SETS["${2}.NOLOG"]=true || __IMPORT_SAVE_SETS["${2}.NOLOG"]=false
    [ -o notify ] && __IMPORT_SAVE_SETS["${2}.NOTIFY"]=true || __IMPORT_SAVE_SETS["${2}.NOTIFY"]=false
    [ -o nounset ] && __IMPORT_SAVE_SETS["${2}.NOUNSET"]=true || __IMPORT_SAVE_SETS["${2}.NOUNSET"]=false
    [ -o onecmd ] && __IMPORT_SAVE_SETS["${2}.ONECMD"]=true || __IMPORT_SAVE_SETS["${2}.ONECMD"]=false
    [ -o physical ] && __IMPORT_SAVE_SETS["${2}.PHYSICAL"]=true || __IMPORT_SAVE_SETS["${2}.PHYSICAL"]=false
    [ -o pipefail ] && __IMPORT_SAVE_SETS["${2}.PIPEFAIL"]=true || __IMPORT_SAVE_SETS["${2}.PIPEFAIL"]=false
    [ -o posix ] && __IMPORT_SAVE_SETS["${2}.POSIX"]=true || __IMPORT_SAVE_SETS["${2}.POSIX"]=false
    [ -o privileged ] && __IMPORT_SAVE_SETS["${2}.PRIVILEGED"]=true || __IMPORT_SAVE_SETS["${2}.PRIVILEGED"]=false
    [ -o verbose ] && __IMPORT_SAVE_SETS["${2}.VERBOSE"]=true || __IMPORT_SAVE_SETS["${2}.VERBOSE"]=false
    [ -o vi ] && __IMPORT_SAVE_SETS["${2}.VI"]=true || __IMPORT_SAVE_SETS["${2}.VI"]=false
    [ -o xtrace ] && __IMPORT_SAVE_SETS["${2}.XTRACE"]=true || __IMPORT_SAVE_SETS["${2}.XTRACE"]=false

elif [ "${1}" = "restore" ] && ( declare -A -p __IMPORT_SAVE_SETS 2>&1 > /dev/null )
then
    for var in "${!__IMPORT_SAVE_SETS[@]}"
    do
        if  [[ "${var}" != "${2}."* ]]
        then
            continue
        fi

        case "${var}" in
            *.ALLEXPORT)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o allexport || set +o allexport
                ;;
            *.BRACEEXPAND)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o braceexpand || set +o braceexpand
                ;;
            *.EMACS)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o emacs || set +o emacs
                ;;
            *.ERREXIT)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o errexit || set +o errexit
                ;;
            *.ERRTRACE)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o errtrace || set +o errtrace
                ;;
            *.FUNCTRACE)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o functrace || set +o functrace
                ;;
            *.HASHALL)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o hashall || set +o hashall
                ;;
            *.HISTEXPAND)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o histexpand || set +o histexpand
                ;;
            *.HISTORY)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o history || set +o history
                ;;
            *.IGNOREEOF)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o ignoreeof || set +o ignoreeof
                ;;
            *.KEYWORD)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o keyword || set +o keyword
                ;;
            *.MONITOR)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o monitor || set +o monitor
                ;;
            *.NOCLOBBER)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o noclobber || set +o noclobber
                ;;
            *.NOEXEC)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o noexec || set +o noexec
                ;;
            *.NOGLOB)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o noglob || set +o noglob
                ;;
            *.NOLOG)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o nolog || set +o nolog
                ;;
            *.NOTIFY)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o notify || set +o notify
                ;;
            *.NOUNSET)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o nounset || set +o nounset
                ;;
            *.ONECMD)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o onecmd || set +o onecmd
                ;;
            *.PHYSICAL)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o physical || set +o physical
                ;;
            *.PIPEFAIL)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o pipefail || set +o pipefail
                ;;
            *.POSIX)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o posix || set +o posix
                ;;
            *.PRIVILEGED)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o privileged || set +o privileged
                ;;
            *.VERBOSE)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o verbose || set +o verbose
                ;;
            *.VI)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o vi || set +o vi
                ;;
            *.XTRACE)
                [ "${__IMPORT_SAVE_SETS[${var}]}" = "true" ] && set -o xtrace || set +o xtrace
                ;;
        esac
        unset __IMPORT_SAVE_SETS["${var}"]
    done

    if [ "${#__IMPORT_SAVE_SETS[@]}" -eq 0 ]
    then
        unset __IMPORT_SAVE_SETS
    fi

elif [ "${1}" = "view" ] && ( declare -A -p __IMPORT_SAVE_SETS 2>&1 > /dev/null )
then
    declare -A -p __IMPORT_SAVE_SETS

elif [ "${1}" != "save" ] && [ "${1}" != "restore" ] && [ "${1}" != "view" ]
then
    echo "ERROR: preserve_set must either call 'save' or 'restore'." 1>&2
    exit 1
fi
