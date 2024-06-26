param (
    [string]$ContainerId
)

docker exec -it $ContainerId /root/start.sh
