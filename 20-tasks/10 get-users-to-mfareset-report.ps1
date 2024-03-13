<#---
title: Report Users to MFA reset
connection: sharepoint
input: users.mfareset.done.json
tag: reset-users-to-mfareset
api: post
---

## A file is extract from SharePoint containing the users to reset

#>

param ($domain = "pep.pl")

$listname = "Guests $domain"
$items = Get-Content "$env:WORKDIR/users.mfareset.done.json" | ConvertFrom-Json


Connect-PnPOnline -Url $ENV:SITEURL  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"

foreach ($item in $items) {
  
    Set-PnPListItem -List $listname  -Identity $item.ID -Values @{
        "Action"                     = "Done"
        
    } 

}

$result = "SharePoint updated"

