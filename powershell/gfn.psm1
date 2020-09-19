param (
    [Parameter()]
    [string]
    $genFolder = $env:CONFIG_GENERATED
)

$generated = "$genFolder\gfn"
if (-not (Test-Path $generated)) {
    New-Item -ItemType Directory -Force -Path $generated
}

foreach ($item in (Get-ChildItem $generated)) {
    try {
        Import-Module "$generated\$item" -Global
    } catch {
        Write-Error "Error importing gfn '${item.BaseName}', removing it..."
        Clear-Permenant-Alias $item.BaseName
    }
}   
function Set-Permenant-Alias($name, $target) {
    $outFile = "$generated\$name.psm1"
    "function $name() { $target };Export-ModuleMember -Function $name" | Out-File $outFile
    try {
        Import-Module $outFile -Global -Force
    } catch {
        Clear-Permenant-Alias $name
    }
}
function Clear-Permenant-Alias($name) {
    $module = "$generated\$name.psm1"
    Remove-Module $name
    Remove-Item  $module
}

function Get-Permenant-AliasList() {
    foreach ($item in (Get-ChildItem $generated)) {
        Write-Output $item.BaseName
    }
}

function gfn() {
    [CmdletBinding()]
    param (
        # Alias for the function
        [Parameter(Position=0)]
        [string]
        $name,
        # function body
        [Parameter(Position=1,ValueFromRemainingArguments)]
        [string]
        $body,
        # Parameter help description
        [Parameter()]
        [Alias("d")]
        [switch]
        $delete = $false,
        [Parameter()]
        [Alias("l")]
        [switch]
        $list = $false
        
    )
    if ($list) {
        return Get-Permenant-AliasList
    } elseif ($delete -and $name) {
        Clear-Permenant-Alias $name
    } elseif ($name -and $body) {
        Set-Permenant-Alias $name $body
    } else {
        Write-Error "Invalid Invocation"
    }

}
