$env:CONFIG_ROOT = $PSScriptRoot
$env:XDG_CONFIG_ROOT = $env:CONFIG_ROOT
$env:CONFIG_GENERATED = "$env:CONFIG_ROOT\__generated__"
if (-not (Test-Path $env:CONFIG_GENERATED)) {
    mkdir $env:CONFIG_GENERATED
}

# Run ps1 script as admin
function asAdmin($file) {
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "powershell"
    $pinfo.Arguments = "-File $PSScriptRoot\powershell\$file.ps1"
    $pinfo.Verb = "runas"
    $pinfo.WorkingDirectory = get-location;
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
}

# Set command alias
function Set-Global-Alias($command, $target) {
    Set-Alias -Name $command -Value $target -Option AllScope -Scope Global    
}

# install choco
if (-not (Get-Command choco -errorAction SilentlyContinue)) {
    Write-Host "choco is not installed, installing..."
    asAdmin "choco"
}
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

if (-not (Get-Command rustup -errorAction SilentlyContinue)) {
    Write-Host "rustup is not installed, installing from https://sh.rustup.rs..."
    (Invoke-WebRequest --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) | sh
}

if (-not (Get-Command nvim -errorAction SilentlyContinue)) {
    Write-Host "nvim is not installed, installing from choco..."
    asAdmin "nvim"
    new-item -ItemType SymbolicLink -Value "$env:CONFIG_ROOT\nvim" -Path "~\AppData\Local\nvim"
    $file = Invoke-WebRequest -useb "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    New-Item $file $HOME/vimfiles/autoload/plug.vim -Force
}
$env:EDITOR = "nvim"
Set-Global-Alias vim nvim
Set-Global-Alias vi nvim
Set-Global-Alias v nvim

function Confirm-Cargo-Install($command, $crateName = $command) {
    if (-not (Get-Command $command -errorAction SilentlyContinue)) {
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

# tokei - tool for counting lines of code
Confirm-Cargo-Install "tokei"

Set-Global-Alias open Invoke-Item
Set-Global-Alias g git
function Get-Git-Status() { git status }
Export-ModuleMember -Function Get-Git-Status
Set-Global-Alias gs Get-Git-Status

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
				Write-Warning "'$Name' isn't a cmdlet, function, script file, file path, or operable program.";
			}
		}.GetNewClosure()
	}
}

function touch($file) {
    "" | Out-File $file -Encoding ASCII
}
Export-ModuleMember -Function touch

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}
Export-ModuleMember -Function which

function sudo {
    $file, [string]$arguments = $args;
    $psi = new-object System.Diagnostics.ProcessStartInfo $file;
    $psi.Arguments = $arguments;
    $psi.Verb = "runas";
    $psi.WorkingDirectory = get-location;
    [System.Diagnostics.Process]::Start($psi) >> $null
}
Export-ModuleMember -Function sudo

Import-Module "$env:CONFIG_ROOT\powershell\vs.psm1" -Global
Import-Module "$env:CONFIG_ROOT\powershell\keybindings.psm1" -Global
Import-Module "$env:CONFIG_ROOT\powershell\gfn.psm1" -Global -DisableNameChecking