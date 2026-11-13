. "$PSScriptRoot/utils.ps1"

$engine = Get-ContainerEngine

& $engine images ${DOCKER_DEV_ENV} --format="{{ .Tag }}"
