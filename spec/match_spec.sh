date_right=2019-05-28
date_wrong=20x9-e3-93
date_regex="[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])"

Describe "match"
    It "matches a string against a regular expression"
        When call match -E "${date_regex}" "${date_right}"
        The status should equal 0
    End

    It "fails when there is a string that does not match it"
        When call match -E "${date_regex}" "${date_wrong}"
        The status should equal 1
    End

    It "when given multiple strings, fails if any string does not match the expression"
        When call match -E "${date_regex}" "${date_right}" "${date_wrong}"
        The status should equal 1
    End
End

