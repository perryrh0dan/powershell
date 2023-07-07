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

Function find_git_remote_branches_with_authores {
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

Function connect_dev_server {
	ssh $DEV_ENV
}

## Set tool aliases
Set-Alias watch watch_something 
Set-Alias find_port find_process_using_port
Set-Alias reload reload_path
Set-Alias git_remote_branches find_git_remote_branches_with_authores

## Set application aliases
Set-Alias pl passline

## Set other aliases
Set-Alias dev connect_dev_server
