Describe "integer"
    It "succeeds when given a non-negative integer"
        When call integer 1
        The status should equal 0
    End

    It "fails when given a negative integer"
        When call integer -1
        The status should equal 1
    End

    It "fails when the argument is not an integer"
        When call integer one
        The status should equal 1
    End

    It "succeeds when multiple arguments are given, all of them a non-negative integers"
        When call integer 1 2 3
        The status should equal 0
    End

    It "fails when multiple arguments are given, none of them a non-negative integers"
        When call integer one two three
        The status should equal 1
    End

    It "fails when multiple arguments are given, only one of them being a non-negative integers"
        When call integer 1 two three
        The status should equal 1
    End
End

