<#---
title: Unlock Batch of Users 
input: users.tounlock.json
output: users.unlocked.json
connection: sharepoint   # az should be used 
tag: unlock-users
---#>

$result = "$env:WORKDIR/users.unlocked.json"
$users = Get-Content "$env:WORKDIR/users.tounlock.json" | ConvertFrom-Json

<#
Setup an array for returning results
#>
$usersUpdated = @(

)

foreach ($user in $users) {
    $response = @{
        ID    = $user.ID
        Email = $user.Email
    }
    if ($user.user -eq $null) {
        $response.HasError = $true
        $response.Error = "UPN not found for email"
    }
    else {
       
        try {
			write-host "Enabling $($user.user.UserPrincipalName)" 
            set-azureaduser -ObjectId $user.user.UserPrincipalName -AccountEnabled $true
            $response.HasError = $false
        }
        catch {
            $response.HasError = $true
            $response.Error = $_.Exception.Message
			write-host $_.Exception.Message
            # Do this if a terminating exception happens
        }
    }
   
    $usersUpdated += $response
}

$usersUpdated | ConvertTo-Json -Depth 10 | Out-File -FilePath $result -Encoding utf8NoBOM
             