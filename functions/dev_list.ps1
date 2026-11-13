. "$PSScriptRoot/utils.ps1"

$engine = Get-ContainerEngine

& $engine volume ls --filter label=dev=yes --format "{{.Name}}"
