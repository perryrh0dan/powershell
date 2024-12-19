param (
  [string]$email,
  [string]$name,
  [string]$keyid
)

. "$PSScriptRoot/identities.ps1"

SaveIdentity -email $email -name $name -keyid $keyid

