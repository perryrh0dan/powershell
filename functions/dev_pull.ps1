. "$PSScriptRoot/config.ps1"
. "$PSScriptRoot/utils.ps1"

$engine = Get-ContainerEngine

$data = LoadRaw | ConvertFrom-Json
$tags = $data.tag | Where-Object { -not [String]::IsNullOrEmpty($_) } | ForEach-Object { $_.Trim() } | Sort-Object | Get-Unique

& $engine pull ${DOCKER_DEV_ENV}
foreach ($tag in $tags) {
    & $engine pull ${DOCKER_DEV_ENV}:$tag
}
