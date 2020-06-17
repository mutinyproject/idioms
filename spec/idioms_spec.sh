_idioms_colors=false
. idioms

Describe 'idioms'
    Describe 'stderr'
        It 'prints to standard error'
            When call stderr 'this should be in standard error\n'
            The status should equal 0
            The stderr lines should equal 1
            The stderr should equal 'this should be in standard error'
        End

        It 'takes variables just like printf'
            When call stderr 'variables %s' 'work'
            The status should equal 0
            The stderr lines should equal 1
            The stderr should equal 'variables work'
        End
    End

    Describe 'note'
        It 'prints a note ("note: ${message}") to stdout'
            When call note 'noted'
            The status should equal 0
            The stderr length should equal 0
            The stdout should equal 'note: noted'
        End

        It 'always adds a newline to the end, like `echo`'
            When call note 'noted'
            The status should equal 0
            The stdout should equal 'note: noted'
            The stdout lines should equal 1
        End
    End

    Describe 'warn'
        It 'prints a warning ("warning: ${message}") to stderr'
            When call warn 'warned'
            The status should equal 0
            The stdout length should equal 0
            The stderr should equal 'warning: warned'
        End

        It 'always adds a newline to the end, like `echo`'
            When call warn 'warned'
            The status should equal 0
            The stderr should equal 'warning: warned'
            The stdout length should equal 0
            The stderr lines should equal 1
        End
    End

    Describe 'error'
        It 'prints an error ("error: ${message}") to stderr'
            When call error 'errored'
            The status should equal 1
            The stdout length should equal 0
            The stderr should equal 'error: errored'
        End

        # `When run` must be used here rather than `When call`, because `run` will not catch
        # the exit and shellspec will think it is a problem.
        It 'dies if you specify the -d option'
            When run error -d 'errored'
            The status should equal 1
            The stdout length should equal 0
            The stderr lines should equal 1
            The line 1 of stderr should equal 'error: errored'
        End

        It 'returns with a specific errno if you specify -e ERRNO'
            When call error -e 123 'errored'
            The status should equal 123
            The stderr lines should equal 1
        End

        # Same here.
        It 'dies with a specific errno if you specify -e ERRNO'
            When run error -de 123 'errored'
            The status should equal 123
            The stderr lines should equal 1
        End

        It 'always adds a newline to the end, like `echo`'
            When call error 'errored'
            The status should equal 1
            The stderr should equal 'error: errored'
            The stdout length should equal 0
            The stderr lines should equal 1
        End
    End

    Describe 'die'
        It 'exits unsuccessfully when no arguments are specified'
            When run die
            The status should equal 1
            The stdout length should equal 0
            The stderr length should equal 0
        End

        It 'exits unsuccessfully, with a message to stderr when arguments are specified'
            When run die 'dying'
            The status should equal 1
            The stdout length should equal 0
            The line 1 of stderr should equal 'dying: dying'
        End
    End

    Describe 'call'
        It 'runs a command within the same shell (`exit` would exit the calling shell)'
            When call call echo 'echoed'
            The status should equal 0
            The stdout lines should equal 1
            The stderr lines should equal 1
            The line 1 of stdout should equal 'echoed'
            The line 1 of stderr should equal '+ echo echoed'
        End

        It 'dies with the error code of the command it called'
            # Running `call exit 123` doesn't make sense here since it would just kill the shell
            # that is running the function.
            When run call sh -c 'exit 123'
            The status should equal 123
            The stderr lines should equal 2
            The stdout lines should equal 0
            The line 1 of stderr should equal '+ sh -c exit 123'
            The line 2 of stderr should equal 'error: command `sh -c exit 123` exited with 123'
        End

        It 'dies with a message if the command fails (using `error -d`)'
            When run call false
            The status should equal 1
            The stderr lines should equal 2
            The stdout lines should equal 0
            The line 1 of stderr should equal '+ false'
            The line 2 of stderr should equal 'error: command `false` exited with 1'
        End

        It 'does not die if you specify -k, and instead shows a warning, exiting successfully'
            When call call -k false
            The status should equal 0
            The stderr lines should equal 2
            The line 1 of stderr should equal '+ false'
            The line 2 of stderr should equal 'warning: command `false` exited with 1'
        End

        It 'does not interpret arguments after the first non-dash-prefixed argument'
            When call call true -n
            The status should equal 0
            The stderr lines should equal 1
            The line 1 of stderr should equal '+ true -n'
        End
    End
End
