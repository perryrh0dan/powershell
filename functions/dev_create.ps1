param (	
	[string]$Name
)

docker volume create --label=dev=yes $Name
