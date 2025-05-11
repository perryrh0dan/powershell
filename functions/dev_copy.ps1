param (
    [string]$Name,
    [string]$Path
)

Get-Clipboard | docker exec -i $Name sh -c "cat > ${Path}"
