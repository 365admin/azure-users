<#---
title: Report Blocked Users
input: users.found.json
output: users.blocked.json
connection: sharepoint
tag: report-blocked-users
---

#>
$result = "$env:WORKDIR/users.blocked.json"
$UsersBlocked   = get-content "$env:WORKDIR/users.found.json" 
| ConvertFrom-Json 
| where-object AccountEnabled -eq $false
| select DisplayName, UserPrincipalName, Mail, AccountEnabled,UserState
<#
## Step 4 
Write the result to file
#>
$UsersBlocked | ConvertTo-Json -Depth 10 | Out-File -FilePath $result -Encoding utf8NoBOM
