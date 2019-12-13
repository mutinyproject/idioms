#!/bin/sh

export topdir="${1:-$PWD}"
export test_success=0
export test_failed=0
export test_num=0

if [ -t 1 ];then
    color_bold='\e[1m'
    color_red='\e[1;31m'
    color_green='\e[1;32m'
    color_reset='\e[0m'
fi

test_num=0

expect_out() {
    description="${1}"; shift
    export test_num=$(( test_num + 1 ))
    expecting="${1}"; shift
    output=$(eval "${@}" 2>&1)
    if [ "${output}" = "${expecting}" ];then
        export test_success=$(( test_success + 1 ))
        printf "${color_green}ok %s %s${color_reset}\n" "${test_num}" "$*"
    else
        export test_failed=$(( test_failed + 1 ))
        printf "${color_red}not ok %s %s${color_reset}\n" "${test_num}" "$*"
        printf '    %s\n' "Expected:"
        printf '%s\n' "${expected}" | while read line;do
            printf '    %s\n' "${line}"
        done
        printf '# %s\n' "Output:"
        printf '%s\n' "${output}" | while read line;do
            printf '    %s\n' "${line}"
        done
    fi
    description=
}

expect_exit() {
    description="${1}"; shift
    export test_num=$(( test_num + 1 ))
    expecting="${1}"; shift
    err=0
    "${@}" || err=$?
    if [ "${err}" -eq "${expecting}" ];then
        test_success=$(( test_success + 1 ))
        printf "${color_green}ok %s%s${color_reset}\n" "${test_num}" "${description:+ - $description}"
    else
        test_failed=$(( test_failed + 1 ))
        printf "${color_red}not ok %s%s${color_reset}\n" "${test_num}" "${description:+ - $description}"
        printf '# %s\n' "$*"
    fi
    description=
    err=
}

new_set() {
    printf "${color_bold}# %s${color_reset}\n" "$@"
}

me=$(readlink -f "${0}")

for f in "${topdir}"/test/*/*.sh;do
    printf '1..%s\n' $(grep -Ec '^expect_(exit|out) ' "${topdir}"/test/*/*.sh)
    f_pretty="${f##$topdir/test/}"
    new_set "${f_pretty}"
    . "${f}"
done

[ "${test_failed}" -eq 0 ] || exit 1
