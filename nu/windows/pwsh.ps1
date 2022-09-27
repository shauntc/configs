Param(
    # Delete function name
    [Parameter()]
    [Alias("a")]
    [switch]
    $admin = $false,

    [parameter(
        ValueFromRemainingArguments = $true
    )]
    [String[]]
    $RemainingArgs
)

$command = $RemainingArgs -join " "
if ($admin) {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "powershell.exe"
    $newProcess.Arguments = $RemainingArgs;
    $newProcess.Verb = "runas";

    [System.Diagnostics.Process]::Start($newProcess);
} else {
    & $command
}