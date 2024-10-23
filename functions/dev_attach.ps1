param (
    [string]$ContainerId
)

docker ps -a -q --filter id=$ContainerId
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    docker exec -it $ContainerId /root/start.sh
} else {
    Write-Host "Could not find a container with id: ${ContainerId}"
}
