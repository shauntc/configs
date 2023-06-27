export def pwsh [
    --admin (-a): bool
    ...params: string] {
    let command = ($params | str join ' ')
    let dir = $env.PWD
    let $scriptpath = ($env.CONFIG_ROOT | path join 'nu/windows/pwsh.ps1')
    if $admin {
        powershell -NoProfile -NoLogo -File $scriptpath $command
    } else {
        powershell -NoProfile -NoLogo -Command $"($scriptpath) ($command)"
    }
}

