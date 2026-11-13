param (
    [string]$Name
)

. "$PSScriptRoot/utils.ps1"

$engine = Get-ContainerEngine

& $engine volume rm $Name $Name-history $Name-resurrect
