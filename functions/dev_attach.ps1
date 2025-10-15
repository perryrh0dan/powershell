param (
    [string]$ContainerId
)

docker ps -a -q --filter id=$ContainerId
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    $Host.UI.RawUI.WindowTitle = "dev ${ContainerId}"

    docker exec -it $ContainerId /bin/zsh

    # Undo title change
    $Host.UI.RawUI.WindowTitle = "Windows PowerShell"

} else {
    Write-Host "Could not find a container with id: ${ContainerId}"
}
