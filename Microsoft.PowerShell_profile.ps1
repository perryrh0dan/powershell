. $PSScriptRoot\variables.ps1

## Declare functions
Function watch_something { 
	Clear-Host;
	while ($true) {
		$command = ""
		for ($i=0; $i -lt $args.length; $i++){
   			 $command += $args[$i] + " "   
		} 
		$scriptBlock = [scriptblock]::Create($command); 
		$output = Invoke-Command -ScriptBlock $scriptBlock
		Clear-Host;
		Write-Output $output
		Start-Sleep 2;
	} 
}

Function find_process_using_port {
	$port = $args[0]
	Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess
}

Function reload_path {
	$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
	Write-Host "Reloaded successful" -ForegroundColor Green
}

Function list_remote_branches_with_authores {
	$branches = (git branch -a | Select-String "remotes" | Select-String -NotMatch "HEAD|master|dev")

	for($i=0; $i -lt $branches.length; $i++) {
		$branches[$i] = $branches[$i].ToString().Trim()
	}

	foreach ($branch in $branches) {
		$last_commit = git show $branch
		$tempfile = "$(Split-Path $branch -Leaf)_commit.txt"
		Add-Content $tempfile $last_commit

		$author = (Get-Content $tempfile)[1]
		Write-Host "Branch: $branch, $author"
		Remove-Item $tempfile
	}
}

Function refresh_nat() {
    net stop winnat
    netsh int ipv4 set dynamic tcp start=49152 num=16384
    netsh int ipv6 set dynamic tcp start=49152 num=16384
    net start winnat
}

Function update() {
	# Store current directory to reset it later
	$currentDirectory = Get-Location
	
	Set-Location -Path $PSScriptRoot

	git pull

	Set-Location -Path $currentDirectory
}

## Set tool aliases
Set-Alias watch watch_something 
Set-Alias find_port find_process_using_port
Set-Alias reload reload_path
Set-Alias remote_branches list_remote_branches_with_authores
Set-Alias refresh_nat refresh_nat

## Set application aliases
Set-Alias pl passline

## Set other aliases
Set-Alias -Name dev -Value "$PSScriptRoot/functions/dev.ps1"
Set-Alias -Name dev_list -Value "$PSScriptRoot/functions/dev_list.ps1"
Set-Alias -Name dev_create -Value "$PSScriptRoot/functions/dev_create.ps1"
Set-Alias -Name dev_stop -Value "$PSScriptRoot/functions/dev_stop.ps1"
Set-Alias -Name dev_pull -Value "$PSScriptRoot/functions/dev_pull.ps1"
Set-Alias -Name dev_tags -Value "$PSScriptRoot/functions/dev_tags.ps1"

Set-Alias -Name profile -Value "$PSScriptRoot/functions/profile.ps1"
