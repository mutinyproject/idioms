date_right=2019-05-28
date_wrong=20x9-e3-93
date_regex="[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])"

Describe "match"
    It "demonstrates basic functionality"
        When call match -E "${date_regex}" "${date_right}"
        The status should eq 0
    End

    It "fails when there's no match"
        When call match -E "${date_regex}" "${date_wrong}"
        The status should eq 1
    End

    It "matches all by default (args: one should match and one should not)"
        When call match -E "${date_regex}" "${date_right}" "${date_wrong}"
        The status should eq 1
    End

    It "matches any when -a is given (args: one should and one should not)"
        When call match -a -E "${date_regex}" "${date_right}" "${date_wrong}"
        The status should eq 0
    End

    It "matches any when -a is given (args: neither should match)"
        When call match -a -E "${date_regex}" "${date_wrong}" "${date_wrong}"
        The status should eq 1
    End
End

