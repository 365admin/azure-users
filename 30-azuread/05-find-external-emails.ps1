<#---
title: Find users matching a given domain
output: users.found.json
connection: azuread
tag: find-users
---

## Step 1
Specify the domain to search for
#>
param(
$domain = "pep.pl"
)
<#
## Step 2
Define the output file name and path


```powershell
# Hint - to make current location workdir
$env:WORKDIR = (get-location).path
```
#>
$result = "$env:WORKDIR/users.found.json"
<#
## Step 3
Load the users from Azure AD - Take all then filter them locally in memory - This can take a lot of time
#>
$Users = Get-AzureADUser -All:$true | Where-Object { $_.ProxyAddresses -like "*@$domain" }
<#
## Step 4 
Write the result to file
#>
$Users | ConvertTo-Json -Depth 10 | Out-File -FilePath $result -Encoding utf8NoBOM
