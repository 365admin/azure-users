<#---
title: Get Users to MFA reset
connection: sharepoint
output: users.mfareset.json
tag: get-users-to-mfareset
api: post
---

## A file is extract from SharePoint containing the users to reset

#>

param ($domain = "pep.pl")

$listname = "Guests $domain"
$result = join-path  $env:WORKDIR "users.mfareset.json"

Connect-PnPOnline -Url $ENV:SITEURL  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"

$listItems = Get-PnpListItem -List $listname  | Where-Object { $_.FieldValues.Action -eq "Reset MFA" }

write-host "Items in list: $($listItems.Count)"
$items = @()
foreach ($listitem in $listItems) {
    $item = @{
        ID = $listitem.FieldValues.ID
        UPN = $listitem.FieldValues.UPN
    }
    $items += $item
   
}

$items  | ConvertTo-Json -Depth 10 | Out-File -FilePath $result -Encoding utf8NoBOM
