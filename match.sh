#!/bin/sh

unset GREP_OPTIONS

all=true
any=

while getopts EFa arg; do
    case "${arg}" in
        a)
            any=true
            all=
            ;;
        E)
            pattern_type=-E
            ;;
        F)
            pattern_type=-F
            ;;
    esac
done

shift $(( OPTIND - 1 ))
pattern="${1}"; shift

if [ "$#" -lt 1 ];then
    printf 'usage: %s [-EFa] <pattern> <string ...>\n' "${0##*/}" >&2
    exit 1
fi

[ $(printf '%s\n' "$@" | grep ${pattern_type} -c ${all:+-v} -- "${pattern}") ${all:+-eq 0}${any:+-ne 0} ] || exit 1

