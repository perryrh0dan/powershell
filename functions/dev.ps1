param (	
	[string]$VolumeOrDirectory,
	[string]$Port
)

if ($VolumeOrDirectory) {	
	$directoryOrVolume = $VolumeOrDirectory 

	$commandOutput = docker volume ls --format "{{.Name}}"

	$availableVolumes = ($commandOutput -split "/n")
		
	for($i=0; $i -lt $availableVolumes.length; $i++) {
		$availableVolumes[$i] = $availableVolumes[$i].ToString().Trim()
	}

	$mountType = 'bind'
	if ($availableVolumes -contains $directoryOrVolume) {
		$mountType = 'volume'
	}

	$ports = ""
	if ($Port) {
		$prefix = "-p"
		$mapping = $Port.toString() + ":" + $Port.toString()	
		$ports = $ports + $prefix + $mapping + " " 
	}

	Invoke-Expression "docker run ${ports} --rm --mount type=${mountType},src=${directoryOrVolume},target=/root/workspace --mount type=bind,src=$SSH_DIRECTORY,target=/root/.ssh -it $DOCKER_DEV_ENV"
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
