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

Function dev_env {	
	if ($args.count -ge 1) {	
		$directoryOrVolume = $args[0]

		$commandOutput = docker volume ls --format "{{.Name}}"

		$availableVolumes = ($commandOutput -split "/n")
			
		for($i=0; $i -lt $availableVolumes.length; $i++) {
			$availableVolumes[$i] = $availableVolumes[$i].ToString().Trim()
		}

		$mountType = 'bind'
		if ($availableVolumes -contains $directoryOrVolume) {
			$mountType = 'volume'
		}

		docker run --mount type=${mountType},src=${directoryOrVolume},target=/root/workspace --mount type=bind,src=$SSH_DIRECTORY,target=/root/.ssh -it $DOCKER_DEV_ENV /bin/zsh
	} else {
		$remotes = $REMOTE_DEV_ENV.split(",")
		foreach ($remote in $remotes) {
			try {	
				Write-Host "Connecting to: $remote"
				ssh -o ConnectTimeout=5 $remote
			}
			catch {
				Write-Host "Failed to connect to: $remote"
				<#Do this if a terminating exception happens#>
			}
		}
	}
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

## Set application aliases
Set-Alias pl passline

## Set other aliases
Set-Alias dev dev_env
