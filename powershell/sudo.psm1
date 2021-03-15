param (
    [Parameter()]
    [string]
    $genFolder = $env:CONFIG_GENERATED
)

# Run a command in admin mode
function sudo() {
    [CmdletBinding()]
    param (
        # function body
        [Parameter(Position=0,Mandatory,ValueFromRemainingArguments)]
        [string]
        $body
    )
    $location = Get-Location;
    $sudoFile = "$genFolder\admin.ps1"
    $outFile = "$genFolder\sudo_out.log"
    "Set-Location $location;`r`n$body" | Out-File $sudoFile
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "powershell"
    $pinfo.Arguments = "-Command", "$sudoFile | Tee-Object -FilePath $outFile"
    $pinfo.Verb = "runas"
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    Get-Content $outFile
    Remove-Item $outFile
    Remove-Item $sudoFile
}
Export-ModuleMember -Function sudo
