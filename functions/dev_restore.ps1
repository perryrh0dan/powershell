param (
    [string]$Name,
    [string]$Path
)

. "$PSScriptRoot/dev_create.ps1" $Name

$workspaceMount = "-v ${Name}:/root/workspace"
$historyMount = "--mount type=volume,src=${Name}-history,target=/root/.history"
$zoxideMount = "--mount type=volume,src=dev-zoxide,target=/root/.local/share/zoxide"

$absPath = (Join-Path $PWD $Path) | Resolve-Path
$backupMount = "-v ${absPath}:/backup"

$command = "docker run --rm ${workspaceMount} ${historyMount} ${zoxideMount} ${backupMount} ubuntu /bin/bash -c 'tar xvf /backup/backup.tar && tar xvf /backup/backup-history.tar && tar xvf /backup/backup-zoxide.tar'"

Invoke-Expression $command
