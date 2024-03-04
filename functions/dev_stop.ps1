docker ps -a -q --filter ancestor=registry.tpoe.dev/dev | ForEach-Object { docker stop $_ }
