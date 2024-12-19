param(
  [string]$email
)

. "$PSScriptRoot/identities.ps1"

ActivateIdentity -email $email 
