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
    sudo "./powershell/choco.ps1"
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

function Confirm-Cargo-Install($command, $crateName = $command) {
    if (Check-Command $command) {
        Write-Host "Command $command not available, installing $crateName from cargo"
        Invoke-Expression "cargo install $crateName"
    }    
}

# starship - Command Prompt
Confirm-Cargo-Install "starship"

# bat - cat replacement
Confirm-Cargo-Install "bat"

# exa - ls replacement
Confirm-Cargo-Install "exa" "--git https://github.com/zkat/exa"

# rg - grep replacement
Confirm-Cargo-Install "rg" "ripgrep"

# fzf - fuzzy finder
if (Check-Command fzf) {
    Write-Host "fzf is not installed, installing from choco..."
    sudo "choco install fzf -y"
}

# tokei - tool for counting lines of code
Confirm-Cargo-Install "tokei"
