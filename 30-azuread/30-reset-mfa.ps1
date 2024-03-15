<#---
title: Reset MFA
input: users.mfareset.do.json
connection: azuread, msolservice
output: users.mfareset.done.json
tag: reset-mfa
api: post
---


#>




$users = Get-Content "$env:WORKDIR/users.mfareset.do.json" | ConvertFrom-Json

$usersUpdated = @(

)

foreach ($user in $users) {
    az ad user update --id $user.UPN --set 'user.strongAuthenticationMethods=[]'

    $response = @{
        ID = $user.ID
    
    }
    $usersUpdated += $response
}


$result = "$env:WORKDIR/users.mfareset.done.json"

$usersUpdated | ConvertTo-Json -Depth 10 | Out-File -FilePath $result -Encoding utf8NoBOM

