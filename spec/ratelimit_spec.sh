XDG_RUNTIME_DIR="${TMPDIR:-/tmp}"

print_temp() {
    ratelimit ${@:+"$@"} 2 true &
    (sleep 1 && echo "${XDG_RUNTIME_DIR}"/ratelimit/*.lock)
}

Describe "ratelimit"
    It "runs a command, limiting the rate that it can be ran"
        When run print_temp
        The stdout should equal "${XDG_RUNTIME_DIR}/ratelimit/2469621148.lock"
    End

    It "allows for adding entropy to the lock file's name"
        When run print_temp -e "entropy"
        The stdout should equal "${XDG_RUNTIME_DIR}/ratelimit/4069469580.lock"
    End
End
