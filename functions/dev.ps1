param (	
	[string]$VolumeOrDirectory,
	[string]$Port
)

. "$PSScriptRoot/config.ps1"

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

	$history = "dev-history"
	if ($mountType -eq "volume") {
		$history = $directoryOrVolume + '-history'
	}

	$data = LoadConfig -Name $directoryOrVolume

	$ports = ""
	if ($Port -And $Port -ne "" -And $Port -ne "null") {
		$data.port = $Port
	} elseif ($Port -And $Port -eq "null") {
        $data.port = ""
    }

    if ($data.port -ne "") {
		$prefix = "-p"
		$mapping = $data.port.toString() + ":" + $data.port.toString()	
		$ports = $ports + $prefix + $mapping + " " 
	}

	SaveConfig -Data $data

	Invoke-Expression "docker run ${ports} --rm --mount type=${mountType},src=${directoryOrVolume},target=/root/workspace --mount type=bind,src=$SSH_DIRECTORY,target=/root/.ssh  --mount type=volume,src=$history,target=/root/.history --mount type=bind,src=//var/run/docker.sock,target=//var/run/docker.sock -it $DOCKER_DEV_ENV" 
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
