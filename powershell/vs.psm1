function getVsPath() {
    $vsYears = 2019, 2017;
    $vsTypes = "Enterprise", "Professional", "Community"
    foreach($vsYear in $vsYears) {
        foreach($vsType in $vsTypes) {
            $vsPath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\$vsYear\$vsType";
            if (Test-Path($vsPath)) {
                return $vsPath
            }
        }
    }

}
$VisualStudioPath = getVsPath
if($VisualStudioPath) {
    function vs {
        Param(
            [parameter(
                Position = 0,
                ParameterSetName = "Solution"
            )]
            [String] $SolutionPath,
            [parameter(
                ValueFromRemainingArguments = $true
            )]
            [String[]]
            $RemainingArgs
        )

        if($SolutionPath) {
            $inputPath = $SolutionPath;
            if (-not $SolutionPath.EndsWith('.sln')) {
                $SolutionPath = "$SolutionPath\*.sln"
            }
            $SolutionPath = Resolve-Path $SolutionPath

            if([System.IO.File]::Exists($SolutionPath)) {
                Write-Host "Visual Studio opening $SolutionPath with args $RemainingArgs";
                & "${VisualStudioPath}\Common7\IDE\devenv.exe" $SolutionPath $RemainingArgs;
            } else {
                Write-Host "Error: No Solution found for path: $inputPath" -BackgroundColor Red;
            }
        } else {
            Write-Host "Open Visual Studio $RemainingArgs";
            & "${VisualStudioPath}\Common7\IDE\devenv.exe" $RemainingArgs;
        }
    }
    Export-ModuleMember -Function vs

    function avs {
        Param(
            [parameter(
                Position = 0,
                ParameterSetName = "Solution"
            )]
            [String] $SolutionPath,
            [parameter(
                ValueFromRemainingArguments = $true
            )]
            [String[]]
            $RemainingArgs
        )

        if($SolutionPath) {
            $inputPath = $SolutionPath;
            if (-not $SolutionPath.EndsWith('.sln')) {
                $SolutionPath = "$SolutionPath\*.sln"
            }
            $SolutionPath = Resolve-Path $SolutionPath

            if([System.IO.File]::Exists($SolutionPath)) {
                Write-Host "Visual Studio opening $SolutionPath $RemainingArgs";
                $newProcess = new-object System.Diagnostics.ProcessStartInfo("${VisualStudioPath}\Common7\IDE\devenv.exe", "`"$SolutionPath`" $RemainingArgs");
                $newProcess.Verb = "runas";
                [System.Diagnostics.Process]::Start($newProcess);
            } else {
                Write-Host "Error: No Solution found for path: $inputPath" -BackgroundColor Red;
            }
        } else {
            Write-Host "Open Visual Studio $RemainingArgs";
            $newProcess = new-object System.Diagnostics.ProcessStartInfo "${VisualStudioPath}\Common7\IDE\devenv.exe";
            $newProcess.Arguments = $RemainingArgs;
            $newProcess.Verb = "runas";
            [System.Diagnostics.Process]::Start($newProcess);
        }
    }
    Export-ModuleMember -Function avs

    function vscmd {
        $vsBatPath = "${VisualStudioPath}\Common7\Tools\VsDevCmd.bat"
        if([System.IO.File]::Exists($vsBatPath)) {
            $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
            if($isAdmin) {
                Write-Host "Prompt has correct permissions, opening inline" -BackgroundColor Green;
                cmd /k "$vsBatPath";
            } else {
                Write-Host "Elevated Permissions Required, Opening new window" -BackgroundColor Red;
                $newProcess = new-object System.Diagnostics.ProcessStartInfo "cmd";
                $newProcess.Arguments = "/k `"$vsBatPath`"";
                $newProcess.Verb = "runas";
                [System.Diagnostics.Process]::Start($newProcess);
            }
        } else {
            Write-Output "VS Dev Batch file does not exist at: $vsBatPath"
        }
    }
    Export-ModuleMember -Function vscmd
}