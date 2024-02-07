<#---
title: Report Rooms updated
connection: sharepoint
input: rooms.updated.json
tag: report-rooms-updated
---


#>


$rooms = Get-Content "$env:WORKDIR/rooms.updated.json" | ConvertFrom-Json


Connect-PnPOnline -Url $ENV:SITEURL  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"

foreach ($room in $rooms) {
  
    Set-PnPListItem -List Rooms -Identity $room.ID -Values @{
        "Provisioning_x0020_Status" = "Provisioned"
    }

}

$result = "SharePoint updated"
