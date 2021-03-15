# Initialize Powershell Configuration

Import-Module "$env:CONFIG_ROOT\powershell\sudo.psm1" -ArgumentList $env:CONFIG_GENERATED
# Check if command exists and we are in user space
function Check-Command($command) {
    # Don't install things in Admin mode (this is a hack to get around recursive behavior when using sudo)
    return ($env:SHELL_ADMIN -eq $false) -and (-not (Get-Command $command -errorAction SilentlyContinue))
}
# Set command alias
function Set-Global-Alias($command, $target) {
    Set-Alias -Name $command -Value $target -Option AllScope -Scope Global    
}
# install choco
if (Check-Command choco) {
    Write-Host "choco is not installed, installing..."
    sudo "$PSScriptRoot/choco.ps1"
}

# nvim - editor
if (Check-Command nvim) {
    Write-Host "Neovim is not installed, installing from chocolaty..."
    sudo "$PSScriptRoot/nvim.ps1"
}

# rust - rustup/cargo installation
if (Check-Command rustup) {
    Write-Host "rustup is not installed, installing from https://sh.rustup.rs..."

    Read-Host -Prompt "go to https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools, run the downloaded installer, and install 'C++ build tools', when complete press enter to continue"
    $env:PATH = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    $rustInit = "$env:CONFIG_GENERATED\rustup-init.exe"
    Invoke-WebRequest -useb https://win.rustup.rs/x86_64 -OutFile $rustInit
    sudo $rustInit
    Remove-Item $rustInit
    $env:PATH = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

function Confirm-Cargo-Install($command, $crateName = $command) {
    if (Check-Command $command) {
        Write-Host "Command $command not available, installing $crateName from cargo"
        Invoke-Expression "cargo install $crateName"
    }    
}

# starship - Command Prompt
Confirm-Cargo-Install "starship"
# TODO: Add some prompt/method for downloading nerd font 'CaskaydiaCove NF' from nerdfonts

# bat - cat replacement
Confirm-Cargo-Install "bat"

# exa - ls replacement
Confirm-Cargo-Install "exa" "--git https://github.com/zkat/exa"

# rg - grep replacement
Confirm-Cargo-Install "rg" "ripgrep"

# tokei - tool for counting lines of code
Confirm-Cargo-Install "tokei"

# fzf - fuzzy finder
if (Check-Command fzf) {
    Write-Host "fzf is not installed, installing from choco..."
    sudo "choco install fzf -y"
}

Export-ModuleMember
