# Install Chocolatey
if ((Get-ExecutionPolicy) -eq "Restricted") {
    Write-Host "Restricted execution policy, at least AllSigned is required. setting AllSigned..."
    Set-ExecutionPolicy AllSigned
}
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))