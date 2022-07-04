Param(
    # Delete function name
    [parameter()][alias("a")]
    [switch]$admin = $false,

    [parameter(Position = 0, ParameterSetName = "Solution")]
    [String] $SolutionPath,

    [parameter(ValueFromRemainingArguments = $true)]
    [String[]] $RemainingArgs
)

function getVsPath() {
    $vsYears = 2022, 2019, 2017;
    $vsTypes = "Enterprise", "Professional", "Community";
    $programFilesPaths = "${env:ProgramFiles(x86)}", $env:ProgramFiles;
    foreach($vsYear in $vsYears) {
        foreach($vsType in $vsTypes) {
            foreach($programFiles in $programFilesPaths) {
                $vsPath = "$programFiles\Microsoft Visual Studio\$vsYear\$vsType";
                if (Test-Path($vsPath)) {
                    return $vsPath
                }
            }
        }
    }
}

$VisualStudioPath = getVsPath
if (-not $VisualStudioPath) {
    Write-Host "Unable to find Visual Studio installation"
    return
}

if($SolutionPath) {
    $inputPath = $SolutionPath
    if (-not $SolutionPath.EndsWith('.sln')) {
        $SolutionPath = "$SolutionPath\*.sln"
    }
    $SolutionPath = Resolve-Path $SolutionPath

    if([System.IO.File]::Exists($SolutionPath)) {
        Write-Host "Visual Studio opening $SolutionPath $RemainingArgs";
        $newProcess = new-object System.Diagnostics.ProcessStartInfo("${VisualStudioPath}\Common7\IDE\devenv.exe", "`"$SolutionPath`" $RemainingArgs");
        if ($admin) {
            $newProcess.Verb = "runas";
        }
        [System.Diagnostics.Process]::Start($newProcess);
    } else {
        Write-Host "Error: No Solution found for path: $inputPath" -BackgroundColor Red;
    }
} else {
    Write-Host "Open Visual Studio";
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "${VisualStudioPath}\Common7\IDE\devenv.exe";
    $newProcess.Arguments = $RemainingArgs;
    if ($admin) {
        $newProcess.Verb = "runas";
    }
    [System.Diagnostics.Process]::Start($newProcess);
}