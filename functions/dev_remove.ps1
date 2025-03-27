param (
    [string]$Name
)

docker volume rm $Name $Name-history $Name-resurrect
