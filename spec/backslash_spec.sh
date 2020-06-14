sed --version

Describe 'backslash'
    It 'combines line that are continued with a backslash at the end of the line'
        Data
            #|test\
            #|ing
            #|test\\
            #|ing
        End

        When call backslash
        The status should eq 0
        The line 1 of stdout should equal 'testing'
        The line 2 of stdout should equal 'test\\'
        The line 3 of stdout should equal 'ing'
    End
End
