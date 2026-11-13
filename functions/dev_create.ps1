param (	
	[string]$Name
)

. "$PSScriptRoot/utils.ps1"

$engine = Get-ContainerEngine

& $engine volume create --label=dev=yes $Name
