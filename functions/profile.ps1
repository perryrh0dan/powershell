$path = $profile

$parentPath = Split-Path -Path $path -Parent
cd $parentPath
dev .
