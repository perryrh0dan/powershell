param (	
	[string]$VolumeOrDirectory,
	[string[]]$Port
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

    $zoxide = "dev-zoxide"

	$data = LoadConfig -Name $directoryOrVolume

	$ports = ""
    if ($Port -And $Port[0] -eq "null") {
		$data.port = @()
	} elseif ($Port -And $Port.Length -gt 0) {
		$data.port = $Port
	} 

    if ($data.port.Length -gt 0) {
        Write-Host "Starting environment with following ports:" $data.port
		$prefix = "-p"
        foreach ($p in $data.port) {
		    $mapping = $p.toString() + ":" + $p.toString()	
		    $ports = $ports + $prefix + $mapping + " " 
        }
	}

	SaveConfig -Data $data

    # Change tab title in the new windows terminal
    if ($mountType -eq "volume") {
        $Host.UI.RawUI.WindowTitle = "dev ${directoryOrVolume}"
    } else {
        $absPath = (Join-Path $PWD $directoryOrVolume) | Resolve-Path
        $Host.UI.RawUI.WindowTitle = "dev ${absPath}"
    }

    $sshMount = ""
    if ($SSH_DIRECTORY) {
        $sshMount = "--mount type=bind,src=$SSH_DIRECTORY,target=/root/.ssh" 
    }

    $gpgMount = ""
    if ($GPG_DIRECTORY) {
        $gpgMount = "--mount type=bind,src=$GPG_DIRECTORY/pubring.kbx,target=/root/.gnupg/pubring.kbx --mount type=bind,src=$GPG_DIRECTORY/trustdb.gpg,target=/root/.gnupg/trustdb.gpg --mount type=bind,src=$GPG_DIRECTORY/private-keys-v1.d,target=/root/.gnupg/private-keys-v1.d"
    } 

    $dockerMount = "--mount type=bind,src=//var/run/docker.sock,target=//var/run/docker.sock"
    $historyMount = "--mount type=volume,src=$history,target=/root/.history"
    $zoxideMount = "--mount type=volume,src=$zoxide,target=/root/.local/share/zoxide"

	Invoke-Expression "docker run ${ports} --rm --mount type=${mountType},src=${directoryOrVolume},target=/root/workspace $sshMount $gpgMount $historyMount $zoxideMount $dockerMount -it $DOCKER_DEV_ENV" 

    # Undo title change
    $Host.UI.RawUI.WindowTitle = "Windows PowerShell"
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
