<#
title: Enable disable users
#>
param(
$domain = "pep.pl"
)
Get-AzureADUser -All:$true 
| Where-Object { $_.ProxyAddresses -like "*@$domain" } 
| where-object AccountEnabled -eq $false | set-azureaduser -AccountEnabled $true