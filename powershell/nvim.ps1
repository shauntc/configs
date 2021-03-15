Write-Host "nvim is not installed, installing from choco..."
choco install neovim -y
# Symlink neovim config
new-item -ItemType SymbolicLink -Value "$env:CONFIG_ROOT\nvim" -Path "~\AppData\Local\nvim"
# Download vim-plug
Invoke-WebRequest -useb 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' | new-item $env:LOCALAPPDATA/nvim-data/site/autoload/plug.vim -Force
# Run plug install
nvim --headless +PlugInstall +qa