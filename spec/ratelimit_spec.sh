XDG_RUNTIME_DIR="${TMPDIR:-/tmp}"

print_temp() {
    ratelimit ${@:+"$@"} 3 true &
    (sleep 1 && echo "${XDG_RUNTIME_DIR}"/ratelimit/*.lock)
}

Describe "ratelimit"
    It "runs a command, limiting the rate that it can be ran"
        When run print_temp
        The stdout should equal "${XDG_RUNTIME_DIR}/ratelimit/2469621148.lock"
    End
End
