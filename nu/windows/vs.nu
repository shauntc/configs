export def vs [
    --admin (-a): bool
    ...params: string] {
    let command = ($params | str collect ' ')
    let scriptpath = ($env.CONFIG_ROOT | path join 'nu\windows\vs.ps1')

    if $admin {
        powershell -NoProfile -NoLogo -Command $"($scriptpath) ($command) -a"
    } else {
        powershell -NoProfile -NoLogo -Command $"($scriptpath) ($command)"
    }
}