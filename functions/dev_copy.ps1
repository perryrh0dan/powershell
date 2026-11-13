param (
    [string]$Name,
    [string]$Path
)

. "$PSScriptRoot/utils.ps1"

$engine = Get-ContainerEngine

Get-Clipboard | & $engine exec -i $Name sh -c "cat > ${Path}"
