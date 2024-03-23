<#---
title: Find users matching a given domain
output: users.found.json
connection: azuread
tag: find-users
api: post
---

## References
 https://learn.microsoft.com/en-us/azure/active-directory-b2c/user-profile-attributes
 https://cloud.hacktricks.xyz/pentesting-cloud/azure-security/az-azuread

## Step 1
Specify the domain to search for
#>
param(
    $domain = "pep.pl"
    # $domain = "M365x81613217.OnMicrosoft.com"
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

koksmat trace log "Finding users with external emails from $domain - This can take some minutes"

$users = az ad user list --query " [? mail!=null] |  [? contains(mail,'@$domain')]" --output json
$count = ($users | ConvertFrom-Json).Count
koksmat trace log "Found $count users"

<#
## Step 4 
Write the result to file
#>

$Users | Out-File -FilePath $result -Encoding utf8NoBOM
