export def vs [
    solution: path      # The path of the solution file
    --admin(-a)         # Run as administrator
] {
    let scriptpath = ($env.CONFIG_ROOT | path join 'nu\windows\vs.ps1')

    if $admin {
        powershell -NoProfile -NoLogo -Command $"($scriptpath) ($solution) -a"
    } else {
        powershell -NoProfile -NoLogo -Command $"($scriptpath) ($solution)"
    }
}