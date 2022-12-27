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
}

## Set aliases
Set-Alias watch watch_something 
Set-Alias find_port find_process_using_port
Set-Alias reload reload_path