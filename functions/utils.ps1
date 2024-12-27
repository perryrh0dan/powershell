function Check-Docker {
    try {
        docker info *> $null 2>&1
    } catch {
        # Catch and handle the error if Docker is not running
        Write-Output "Docker is not running or the Docker CLI is not configured properly."
        Write-Output "Error: $($_.Exception.Message)"
    }
}
