$env:CONFIG_ROOT = $PSScriptRoot
$env:XDG_CONFIG_ROOT = $env:CONFIG_ROOT
$env:CONFIG_GENERATED = "$env:CONFIG_ROOT\__generated__"
$env:SHELL_ADMIN = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
if (-not (Test-Path $env:CONFIG_GENERATED)) {
    mkdir $env:CONFIG_GENERATED
}

Import-Module "$env:CONFIG_ROOT\powershell\sudo.psm1" -Global -ArgumentList $env:CONFIG_GENERATED
# Import-Module "$env:CONFIG_ROOT\powershell\init.psm1"

function commandExists($command) {
    return (Get-Command $command -errorAction SilentlyContinue)
}
# Set command alias
function Set-Global-Alias($command, $target) {
    Set-Alias -Name $command -Value $target -Option AllScope -Scope Global
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# helix - editor setup
if (commandExists hx) {
    if (-not $env:HELIX_RUNTIME) {
        Write-Host "Helix Editor runtime folder not set, please set 'HELIX_RUNTIME' env var"
    }
    $env:HELIX_CONFIG = "$env:CONFIG_ROOT\helix"
    $env:EDITOR = "hx"
}

# starship - Command Prompt
if (commandExists starship) {
    $env:STARSHIP_CONFIG = "$env:CONFIG_ROOT\starship\config.toml"
    Invoke-Expression (&starship init powershell)
}

# bat - cat replacement
if (commandExists bat) {
    Set-Global-Alias cat bat
}

# exa - ls replacement
if (commandExists exa) {
    Set-Global-Alias ls exa
    Set-Global-Alias l exa
}

# rg - ripgrep grep replacement
if (commandExists rg) {
    Set-Global-Alias grep rg
}

# fzf - fuzzy finder
if (commandExists fzf) {
    $env:FZF_DEFAULT_COMMAND = "rg --files --no-ignore-vcs --hidden"
    $env:FZF_DEFAULT_OPTS = "--layout=reverse --info inline"
    Set-Global-Alias fd fzf
}

# git commmands
if (commandExists git) {
    Set-Global-Alias g git
    function Get-GitStatus() { git status }
    Export-ModuleMember -Function Get-GitStatus
    Set-Global-Alias gs Get-GitStatus
}

# Increase the history length
Set-Variable MaximumHistoryCount 8192 -Scope Global

Set-Global-Alias open Invoke-Item

if (commandExists python) {
    Set-Global-Alias python3 python
}

# Run when a command is not found
$ExecutionContext.InvokeCommand.CommandNotFoundAction = {
    param($Name, [System.Management.Automation.CommandLookupEventArgs]$CommandLookupArgs)

    # Check if command was directly invoked by user
    # For a command invoked by a running script, CommandOrigin would be `Internal`
    if ($CommandLookupArgs.CommandOrigin -eq 'Runspace') {
        # Assign a new action scriptblock, close over $Name from this scope
        $CommandLookupArgs.CommandScriptBlock = {
            if (Test-Path($Name)) {
                # navigate without cd
                Set-Location $Name;
            }
            elseif ($Name -cmatch "^get-\.\.+$") {
                #if it's a bunch of dots, go up dirs
                $num = ($Name -replace "get-").Length - 1;
                $directory = [System.String]::Join("/", @("..") * $num)
                Set-Location $directory
            }
            else {
                Write-Warning "'$Name' isn't a cmdlet, function, script file, file path, or operable program.";
            }
        }.GetNewClosure()
    }
}

Import-Module "$env:CONFIG_ROOT\powershell\vs.psm1" -Global
Import-Module "$env:CONFIG_ROOT\powershell\keybindings.psm1" -Global
Import-Module "$env:CONFIG_ROOT\powershell\unix.psm1" -Global
Import-Module "$env:CONFIG_ROOT\powershell\gfn.psm1" -Global -ArgumentList $env:CONFIG_GENERATED
