param (
    [string]$Name,
    [string]$Path
)

. "$PSScriptRoot/dev_create.ps1" $Name
. "$PSScriptRoot/utils.ps1"

$engine = Get-ContainerEngine

if (-not (Check-Engine)) {
    return
}

$utilityImage = $DEV_UTILITY_IMAGE
if (-not $utilityImage) {
    $utilityImage = "docker.io/library/ubuntu"
}

$workspaceMount = "-v ${Name}:/root/workspace"
$historyMount = "--mount type=volume,src=${Name}-history,target=/root/.history"
$zoxideMount = "--mount type=volume,src=dev-zoxide,target=/root/.local/share/zoxide"

$absPath = (Join-Path $PWD $Path) | Resolve-Path
$backupMount = "-v ${absPath}:/backup"

$command = "${engine} run --rm ${workspaceMount} ${historyMount} ${zoxideMount} ${backupMount} ${utilityImage} /bin/bash -c 'tar xvf /backup/backup.tar && tar xvf /backup/backup-history.tar && tar xvf /backup/backup-zoxide.tar'"

Invoke-Expression $command
