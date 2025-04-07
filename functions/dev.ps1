param (	
	[string]$VolumeOrDirectory,
	[string[]]$Port,
  [string]$Tag
)

. "$PSScriptRoot/config.ps1"
. "$PSScriptRoot/identities.ps1"

if ($VolumeOrDirectory) {
    $directoryOrVolume = $VolumeOrDirectory
    $name = ""

    $commandOutput = docker volume ls --format "{{.Name}}"

    $availableVolumes = ($commandOutput -split "/n")

    for($i=0; $i -lt $availableVolumes.length; $i++) {
        $availableVolumes[$i] = $availableVolumes[$i].ToString().Trim()
    }

    $mountType = 'bind'
    if ($availableVolumes -contains $directoryOrVolume) {
        $mountType = 'volume'
        $name = "--name=$directoryOrVolume"
    }

    $history = "dev-history"
    if ($mountType -eq "volume") {
        $history = $directoryOrVolume + '-history'
    }

    $zoxide = "dev-zoxide"

    $tmuxResurrect = "dev-resurrect"
    if ($mountType -eq "volume") {
        $tmuxResurrect = $directoryOrVolume + '-resurrect'
    }

    $data = LoadConfig -Name $directoryOrVolume

    if ($Port -And $Port[0] -eq "null") {
        $data.port = @()
    } elseif ($Port -And $Port.Length -gt 0) {
        $data.port = $Port
    }

    $ports = ""
    if ($data.port.Length -gt 0) {
        $prefix = "-p"
        foreach ($p in $data.port) {
            $mapping = $p.toString() + ":" + $p.toString()
            $ports = $ports + $prefix + $mapping + " "
        }
    }
    
    if ($Tag -AND $Tag -eq "null") {
        $data.tag = "" 
    } elseif ($Tag -And $Tag -ne "") {
        $data.tag = $Tag
    }

    $tag = ""
    if ($data.tag -And $data.tag -ne "") {
        $tag = ":$($data.tag)"
    }

    SaveConfig -Data $data
    
    Write-Host "Starting environment with:"
    Write-Host "Ports:" $data.port
    Write-Host "Tag:" $data.tag

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
	
	$npmMount = ""
    if ($NPM_FILE) {
        $npmMount = "--mount type=bind,src=$NPM_FILE,target=/root/.npmrc" 
    }

    $gpgMount = ""
    if ($GPG_DIRECTORY) {
        $gpgMount = "--mount type=bind,src=$GPG_DIRECTORY/pubring.kbx,target=/root/.gnupg/pubring.kbx --mount type=bind,src=$GPG_DIRECTORY/trustdb.gpg,target=/root/.gnupg/trustdb.gpg --mount type=bind,src=$GPG_DIRECTORY/private-keys-v1.d,target=/root/.gnupg/private-keys-v1.d"
    }

    $sharedMount = ""
    if ($SHARED_DIRECTORY) {
        $sharedMount = "--mount type=bind,src=$SHARED_DIRECTORY,target=/root/shared"
    }

    $kubeMount = ""
    if ($KUBE_DIRECTORY) {
        $kubeMount = "--mount type=bind,src=$KUBE_DIRECTORY,target=/root/.kube"
    }

    $ngrokMount = ""
    if ($NGROK_DIRECTORY) {
        $ngrokMount = "--mount type=bind,src=$NGROK_DIRECTORY,target=/root/.config/ngrok"
    }

    $dockerMount = "--mount type=bind,src=//var/run/docker.sock,target=//var/run/docker.sock"
    $historyMount = "--mount type=volume,src=$history,target=/root/.history"
    $zoxideMount = "--mount type=volume,src=$zoxide,target=/root/.local/share/zoxide"
    $tmuxResurrectMount = "--mount type=volume,src=$tmuxResurrect,target=/root/.local/share/tmux/resurrect"

    $identityEnv = ""
    $activeIdentity = LoadActiveIdentity 
    if($activeIdentity) {
      $identityEnv = "--env GIT_EMAIL=`"${activeIdentity.email}`" --env GIT_USER=`"${activeIdentity.name}`" --env GIT_SIGNINGKEY=`"${activeIdentity.keyid}`""
    }

    $llmKeys = ""
    if ($GEMINI_API_KEY) {
      $llmKeys = "${llmKeys} --env GEMINI_API_KEY=`"${GEMINI_API_KEY}`""
    }
    if ($CLAUDE_API_KEY) {
      $llmKeys = "${llmKeys} --env CLAUDE_API_KEY=`"${CLAUDE_API_KEY}`""
    }


    Invoke-Expression "docker run ${ports} ${name} --privileged --rm ${identityEnv} ${llmKeys} --mount type=${mountType},src=${directoryOrVolume},target=/root/workspace $sshMount $npmMount $gpgMount $sharedMount $historyMount $zoxideMount $tmuxResurrectMount $dockerMount $kubeMount $ngrokMount -it --memory 24gb ${DOCKER_DEV_ENV}${tag}"

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
