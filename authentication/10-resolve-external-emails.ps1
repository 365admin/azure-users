<#---
title: Resolve Batch of Users 
input: users.toresolve.json
output: users.tounlock.json
connection: azuread
tag: resolve-users
---#>

$result = "$env:WORKDIR/users.tounlock.json"
$users = Get-Content "$env:WORKDIR/users.toresolve.json" | ConvertFrom-Json

<#
Setup an array for returning results
#>
$usersUpdated = @(

)

foreach ($user in $users) {
    $response = @{
        ID = $user.ID

    }
    try {
		write-host "Checking $($user.Email)"
        $u = Get-AzureADUser -Filter "proxyAddresses/any(p:startswith(p,'smtp:$($user.Email)'))"
		$response.user = $u
        $response.HasError = $false
    }
    catch {
        $response.HasError = $true
        $response.Error = $_.Exception.Message
        # Do this if a terminating exception happens
    }
   
    $usersUpdated += $response
}

$usersUpdated | ConvertTo-Json -Depth 10 | Out-File -FilePath $result -Encoding utf8NoBOM
             