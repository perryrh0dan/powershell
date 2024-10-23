param (
    [string]$Name
)

$excludes = '--exclude "node_modules" --exclude ".angular" --exclude ".nx" --exclude "dist" --exclude ".pnpm-store" --exclude ".next"'

$workspaceMount = "-v ${Name}:/root/workspace"
$historyMount = "--mount type=volume,src=${Name}-history,target=/root/.history"
$zoxideMount = "--mount type=volume,src=dev-zoxide,target=/root/.local/share/zoxide"

$absPath = Join-Path $PWD "backup-$Name"
$backupMount = "-v ${absPath}:/backup"

$command = "docker run --rm ${workspaceMount} ${historyMount} ${zoxideMount} ${backupMount} ubuntu /bin/bash -c 'tar cvf /backup/backup.tar ${excludes} /root/workspace && tar cvf /backup/backup-history.tar /root/.history && tar cvf /backup/backup-zoxide.tar /root/.local/share/zoxide'"

Invoke-Expression $command
