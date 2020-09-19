$env:CONFIG_ROOT = $PSScriptRoot
if (-not (Get-Command rustup -errorAction SilentlyContinue)) {
    (Invoke-WebRequest --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) | sh
}

if (-not (Get-Command rustup -errorAction SilentlyContinue)) {
    (Invoke-WebRequest --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) | sh
}
$env:EDITOR = nvim

function Confirm-Cargo-Install($command, $crateName = $command) {
    if (-not (Get-Command $command -errorAction SilentlyContinue)) {
        Write-Host "Command $command not available, installing $crateName from cargo"
        Invoke-Expression "cargo install $crateName"
    }    
}

function Set-Global-Alias($command, $target) {
    Set-Alias -Name $command -Value $target -Option AllScope -Scope Global    
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
Set-Global-Alias gs (git status)

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

function sudo {
    $file, [string]$arguments = $args;
    $psi = new-object System.Diagnostics.ProcessStartInfo $file;
    $psi.Arguments = $arguments;
    $psi.Verb = "runas";
    $psi.WorkingDirectory = get-location;
    [System.Diagnostics.Process]::Start($psi) >> $null
}
Export-ModuleMember -Function sudo

function touch($file) {
    "" | Out-File $file -Encoding ASCII
}
Export-ModuleMember -Function touch

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}
Export-ModuleMember -Function which