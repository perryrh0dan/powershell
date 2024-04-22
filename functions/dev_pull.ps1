. "$PSScriptRoot/config.ps1"

$data = LoadRaw | ConvertFrom-Json
$tags = $data.tag | Get-Unique | Where-Object { -not [String]::IsNullOrEmpty($_) }

docker pull ${DOCKER_DEV_ENV}
foreach ($tag in $tags) {
    docker pull ${DOCKER_DEV_ENV}:$tag
}
