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
        Import-Module $item.FullName -Global
    } catch {
        Write-Error "Error importing gfn '${item.BaseName}', removing it..."
        Clear-Permenant-Alias $item.BaseName
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

# create a generated function which persists
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
        # Delete function name
        [Parameter()]
        [Alias("d")]
        [switch]
        $delete = $false,
        [Parameter()]
        [Alias("l")]
        [switch]
        $list = $false,
        # Add function args eg "`$name" which can be referenced in the body
        # use backtick (`) to escape $'s to prevent being interpreted as a variable on the call
        [Parameter()]
        [Alias("a")]
        [string]
        $arguments = ""
    )
    if ($list -and $name) {
        cat "$generated\$name.psm1"
    } elseif ($list) {
        return Get-Permenant-AliasList
    } elseif ($delete -and $name) {
        Clear-Permenant-Alias $name
    } elseif ($name -and $body) {
        $outFile = "$generated\$name.psm1"
        "function $name($arguments) { $body };Export-ModuleMember -Function $name" | Out-File $outFile
        try {
            Import-Module $outFile -Global -Force
        } catch {
            Clear-Permenant-Alias $name
        }
    } else {
        Write-Error "Invalid Invocation"
    }

}
Export-ModuleMember -Function gfn
