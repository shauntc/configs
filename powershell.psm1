$env:CONFIG_ROOT = $PSScriptRoot
$env:XDG_CONFIG_ROOT = $env:CONFIG_ROOT
$env:CONFIG_GENERATED = "$env:CONFIG_ROOT\__generated__"
$env:USER_ADMIN = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host "isAdmin $env:USER_ADMIN"
if (-not (Test-Path $env:CONFIG_GENERATED)) {
    mkdir $env:CONFIG_GENERATED
}

Import-Module "$env:CONFIG_ROOT\powershell\sudo.psm1" -Global -ArgumentList $env:CONFIG_GENERATED
# Check if command exists and we are in user space
function Check-Command($command) {
    # Don't install things in Admin mode (this is a hack to get around recursive behavior when using sudo)
    return ($env:USER_ADMIN -eq $false) -and (-not (Get-Command $command -errorAction SilentlyContinue))
}
# Set command alias
function Set-Global-Alias($command, $target) {
    Set-Alias -Name $command -Value $target -Option AllScope -Scope Global    
}
# install choco
if (Check-Command choco) {
    Write-Host "choco is not installed, installing..."
    sudo "./powershell/choco.ps1"
}
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

if (Check-Command rustup) {
    Write-Host "rustup is not installed, installing from https://sh.rustup.rs..."
    (Invoke-WebRequest --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) | sh
}

if (Check-Command nvim) {
    Write-Host "nvim is not installed, installing from choco..."
    sudo "choco install neovim -y"
    new-item -ItemType SymbolicLink -Value "$env:CONFIG_ROOT\nvim" -Path "~\AppData\Local\nvim"
    $file = Invoke-WebRequest -useb "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    New-Item $file $HOME/vimfiles/autoload/plug.vim -Force
}
$env:EDITOR = "nvim"
Set-Global-Alias vim nvim
Set-Global-Alias vi nvim
Set-Global-Alias v nvim

function Confirm-Cargo-Install($command, $crateName = $command) {
    if (Check-Command $command) {
        Write-Host "Command $command not available, installing $crateName from cargo"
        Invoke-Expression "cargo install $crateName"
    }    
}

# starship - Command Prompt
Confirm-Cargo-Install "starship"
$env:STARSHIP_CONFIG = "$env:CONFIG_ROOT\starship\config.toml"
Invoke-Expression (&starship init powershell)

# bat - cat replacement
Confirm-Cargo-Install "bat"
Set-Global-Alias cat bat

# exa - ls replacement
Confirm-Cargo-Install "exa" "--git https://github.com/zkat/exa"
Set-Global-Alias ls exa
Set-Global-Alias l exa

# rg - ripgrep grep replacement
Confirm-Cargo-Install "rg" "ripgrep"
Set-Global-Alias grep rg

# fzf - fuzzy finder
$env:FZF_DEFAULT_COMMAND = "rg --files --no-ignore-vcs --hidden"
$env:FZF_DEFAULT_OPTS = "--height 20% --layout=reverse --info inline"
if (Check-Command fzf) {
    Write-Host "fzf is not installed, installing from choco..."
    sudo "choco install fzf -y"
}
Set-Global-Alias fd fzf

# tokei - tool for counting lines of code
Confirm-Cargo-Install "tokei"

Set-Global-Alias open Invoke-Item
Set-Global-Alias g git
function Get-Git-Status() { git status }
Export-ModuleMember -Function Get-Git-Status
Set-Global-Alias gs Get-Git-Status

# Increase the history length
Set-Variable MaximumHistoryCount 8192 -Scope Global

# Run when a command is not found
$ExecutionContext.InvokeCommand.CommandNotFoundAction = {
	param($Name,[System.Management.Automation.CommandLookupEventArgs]$CommandLookupArgs)

	# Check if command was directly invoked by user
	# For a command invoked by a running script, CommandOrigin would be `Internal`
	if($CommandLookupArgs.CommandOrigin -eq 'Runspace'){
		# Assign a new action scriptblock, close over $Name from this scope
		$CommandLookupArgs.CommandScriptBlock = {
			if (Test-Path($Name)) { # navigate without cd
				cd $Name;
			}  elseif ($Name -cmatch "^get-\.\.+$") { #if it's a bunch of dots, go up dirs
				$num = ($Name -replace "get-").Length - 1;
				$directory = [System.String]::Join("/", @("..") * $num)
				cd $directory
			} else {
                Get-Command | ForEach-Object {$_.Name } | fzf $Name
				Write-Warning "'$Name' isn't a cmdlet, function, script file, file path, or operable program.";
			}
		}.GetNewClosure()
	}
}

Import-Module "$env:CONFIG_ROOT\powershell\vs.psm1" -Global
Import-Module "$env:CONFIG_ROOT\powershell\keybindings.psm1" -Global
Import-Module "$env:CONFIG_ROOT\powershell\unix.psm1" -Global
Import-Module "$env:CONFIG_ROOT\powershell\gfn.psm1" -Global -ArgumentList $env:CONFIG_GENERATED