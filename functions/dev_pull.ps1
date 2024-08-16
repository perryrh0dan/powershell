. "$PSScriptRoot/config.ps1"

$data = LoadRaw | ConvertFrom-Json
$tags = $data.tag | Where-Object { -not [String]::IsNullOrEmpty($_) } | ForEach-Object { $_.Trim() } | Sort-Object | Get-Unique

docker pull ${DOCKER_DEV_ENV}
foreach ($tag in $tags) {
    docker pull ${DOCKER_DEV_ENV}:$tag
}
