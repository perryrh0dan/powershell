$identitiesPath = "~/.identities.json"

Function LoadIdentity {
  param (
    [string]$email
  )
  $jsonContent = LoadRawIdentities
  $identities = $jsonContent | ConvertFrom-Json
  for ($i = 0; $i -lt $identities.Count; $i++) {
    if ($identities[$i].email -eq $email) {
      return $identities[$i]
    }
  }
  return @{
    email = $email
    name = ""
    keyid = ""
  }
}

Function ActivateIdentity {
  param (
    [string]$email
  )
  $identity = LoadIdentity -email $email
  $keyid = $identity.keyid 
  $name = $identity.name
  SaveIdentity -email $email -keyid $keyid -name $name
}

Function LoadActiveIdentity {
  $jsonContent = LoadRawIdentities
  $identities = $jsonContent | ConvertFrom-Json
  for ($i = 0; $i -lt $identities.Count; $i++) {
    if ($identities[$i].active -eq $true) {
      return $identities[$i]
    }
  }
  return $false
}

Function SaveIdentity {
  param(
    [string]$email,
    [string]$name,
    [string]$keyid
  )
  $jsonContent = LoadRawIdentities
  $existingIdentities = $jsonContent | ConvertFrom-Json
  $identities = New-Object System.Collections.ArrayList
  if ($existingIdentities) {
    for($i = 0; $i -lt $existingIdentities.Count; $i++) {
      $existingIdentities[$i].active = $false
      $identities.Add($existingIdentities[$i])
    }
  }
  $indexToRemove
  for ($i = 0; $i -lt $identities.Count; $i++) {
    if ($identities[$i].email -eq $email) {
        $indexToRemove = $i
        break
    }
  }
  if ($null -ne $indexToRemove) {
    $identities.removeAt($indexToRemove)
  }
  $index = $identities.Add(@{
    email = $email
    name = $name
    keyid = $keyid
    active = $true
  })
  $jsonOutput = ConvertTo-Json @($identities) -Depth 5
  $jsonOutput | Out-File $identitiesPath
}

Function LoadRawIdentities { 
  try {	
    return Get-Content -Raw -Path $identitiesPath 
  }
  catch {
    return "[]"
  }
}
