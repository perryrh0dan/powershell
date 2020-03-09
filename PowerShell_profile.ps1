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
		echo $output
		sleep 2;
			
	} 
}

## Set aliases
Set-Alias watch watch_something 