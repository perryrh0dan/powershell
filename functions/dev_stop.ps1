. "$PSScriptRoot/config.ps1"
. "$PSScriptRoot/utils.ps1"

$engine = Get-ContainerEngine

if (-not (Check-Engine)) {
    return
}

$devImage = $DOCKER_DEV_ENV
if (-not $devImage) {
    return
}

$filter = "--filter ancestor=$devImage"

& $engine ps -a -q $filter | ForEach-Object { & $engine stop $_ }
