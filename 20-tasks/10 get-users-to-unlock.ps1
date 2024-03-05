<#---
title: Get User to resolve
connection: sharepoint
output: users.toresolve.json
tag: get-users-to-resolve
api: post
---

## A file is extract from SharePoint containing the users to resolve and unlock

#>

param (
   
    [string]$SiteURL = "https://christianiabpos.sharepoint.com/sites/nexiintra-hub"
)
$result = "$env:WORKDIR/users.toresolve.json"

#Get-PnPList
#return

Connect-PnPOnline -Url $SiteURL  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"

$listItems = Get-PnpListItem -List "User Voice" 

write-host "Users in list: $($listItems.Count)"
$rooms = @()
foreach ($item in $listItems) {
    $room = @{
        ID = $item.FieldValues.ID
        Title = $item.FieldValues.Title
        Status = $item.FieldValues.Status
        Email = $item.FieldValues.Fromemail
        
    }
    if ($room.Status -eq "New") {
        $rooms += $room
    }

   
}

$rooms | ConvertTo-Json -Depth 10 | Out-File -FilePath $result -Encoding utf8NoBOM
