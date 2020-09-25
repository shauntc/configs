# Powershell analogs of unix commands
function touch($file) {
    "" | Out-File $file -Encoding ASCII
}
Export-ModuleMember -Function touch

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}
Export-ModuleMember -Function which

