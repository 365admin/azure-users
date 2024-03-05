<#---
title: Enable disable users
tag: enable-disabled
api: post
---#>
param(
$domain = "pep.pl"
)
Get-AzureADUser -All:$true 
| Where-Object { $_.ProxyAddresses -like "*@$domain" } 
| where-object AccountEnabled -eq $false | set-azureaduser -AccountEnabled $true