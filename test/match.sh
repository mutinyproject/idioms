#!/usr/bin/hope

date_right=2019-05-28
date_wrong=20x9-e3-93
date_regex="[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])"

expect_exit "does it even work?" 0 match -E "${date_regex}" "${date_right}"
expect_exit "fails with no match" 1 match -E "${date_regex}" "${date_wrong}"
expect_exit "must match all, one match, one not matching" 1 match -E "${date_regex}" "${date_right}" "${date_wrong}"
expect_exit "must match any, one match, one not matching" 0 match -a -E "${date_regex}" "${date_right}" "${date_wrong}"
expect_exit "must match any, none matching" 1 match -a -E "${date_regex}" "${date_wrong}" "${date_wrong}"
