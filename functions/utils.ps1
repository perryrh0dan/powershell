# Returns the configured container engine binary name, defaulting to docker
# when $CONTAINER_ENGINE is unset (variables.ps1 is optional).
function Get-ContainerEngine {
    if ($CONTAINER_ENGINE -and -not [String]::IsNullOrWhiteSpace($CONTAINER_ENGINE)) {
        return $CONTAINER_ENGINE
    }
    return "docker"
}

# Returns the host socket path for the active engine, so the dev container can
# talk to the host engine (engine-in-engine). $CONTAINER_SOCKET overrides.
function Get-ContainerSocket {
    if ($CONTAINER_SOCKET -and -not [String]::IsNullOrWhiteSpace($CONTAINER_SOCKET)) {
        return $CONTAINER_SOCKET
    }

    switch (Get-ContainerEngine) {
        "podman" { return "/run/podman/podman.sock" }
        default  { return "//var/run/docker.sock" }
    }
}

# Returns the --mount argument for the engine socket, or an empty string when
# disabled via $MOUNT_ENGINE_SOCKET = "no".
#
# Existence is deliberately not tested. Under Docker Desktop and podman machine
# the socket lives inside the VM, where PowerShell cannot stat it: Test-Path
# would normalize //var/run/docker.sock to a UNC share and always report false,
# silently dropping the mount. Mounting unconditionally means a wrong socket
# path fails loudly instead.
function Get-EngineSocketMount {
    if ($MOUNT_ENGINE_SOCKET -and $MOUNT_ENGINE_SOCKET.ToLower() -eq "no") {
        return ""
    }

    $socket = Get-ContainerSocket
    return "--mount type=bind,src=$socket,target=$socket"
}

# Verifies the configured engine is installed and responding.
# Returns $true when usable, $false otherwise.
function Check-Engine {
    $engine = Get-ContainerEngine

    if (-not (Get-Command $engine -ErrorAction SilentlyContinue)) {
        Write-Error "$engine is not installed or not on PATH. Set `$CONTAINER_ENGINE in variables.ps1 to 'docker' or 'podman'."
        return $false
    }

    # Native commands set $LASTEXITCODE rather than throwing, so it must be
    # checked explicitly.
    & $engine info *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Error "$engine is not running or the $engine CLI is not configured properly."
        return $false
    }

    return $true
}
