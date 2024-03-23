<#---
title: Sync Users Found to SharePoint
connection: sharepoint
tag: sync-guests
input: users.found.json
api: post
---
#>

param ($domain = "pep.pl")

<#
Load file data and connect to SharePoint
#>

$users = Get-Content "$env:WORKDIR/users.found.json" | ConvertFrom-Json

koksmat trace log "Connecting to SharePoint"
Connect-PnPOnline -Url $ENV:SITEURL  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"
$listname = "Guests $domain"

koksmat trace log "Getting existing SharePoint items"
$listItems = Get-PnpListItem -List $listname

<#
Setup 2 dictionaries to compare the data
#>
$sharePointItems = @{

}

$usersInFile = @{

}

<#
Add existing SharePoint items to the dictionary 
#>

koksmat trace log "Users in list: $($listItems.Count)"
foreach ($listItem in $listItems) {

    $hash = $listItem.FieldValues.UPN + "|"
    if ($listItem.FieldValues.AccountEnabled -eq "True") {
        $hash += "1|"
    }
    else {
        $hash += "0|"
    }
    $hash += $listItem.FieldValues.UserState + "|"
    $hash += $listItem.FieldValues.UserType + "|"
    $sharePointItems.Add($listItem.FieldValues.Title, @{
            id   = $listItem.FieldValues.ID
            hash = $hash
        })
    
}

<#
Iterate over the users and compare with SharePoint

If the user is in SharePoint, check if the data is different and update if necessary.

If the user is not in SharePoint, add it

#>

koksmat trace log "Users in file:  $($users.Count)"
foreach ($user in $users) {
    $hash = $user.userPrincipalName + "|"
    # if ($user.AccountEnabled -eq "True") {
    #     $hash += "1|"
    # }
    # else {
    #     $hash += "0|"
    # }
    # $hash += $user.UserState + "|"
    # $hash += $user.UserType + "|"
    $usersInFile.Add($user.Mail, $user.ObjectId)

    if ($sharePointItems.ContainsKey($user.Mail)) {
        continue # Skipping update for now

        $spItem = $sharePointItems[$user.Mail]
        # write-host "User $($user.Mail) already in SharePoint"
        if ($hash -ne $spItem.hash) {

            koksmat trace log "Updating $($user.Mail) in SharePoint"
            Set-PnPListItem -List $listname -Identity $spItem.id -Values @{
                "AccountEnabled" = $user.AccountEnabled 
                "UserState"      = $user.UserState
                "UserType"       = $user.UserType
            } | Out-Null
        }
        
    }
    else {
        koksmat trace log  "Adding $($user.Mail) to SharePoint"
        Add-PnPListItem -List $listname -Values @{
            "Title" = $user.mail
            "UPN"   = $user.userPrincipalName
            #"AccountEnabled" = $user.AccountEnabled 
            #"UserState"      = $user.UserState
            #"UserType"       = $user.UserType
           
        
        } | Out-Null
    }
}


<#

Iterate over the SharePoint items and remove the ones that are not in the file
#>

foreach ($listItem in $listItems) {
    if (-not $usersInFile.ContainsKey($listItem.FieldValues.Title)) {
        koksmat trace log  "Removing $($listItem.FieldValues.Title) from SharePoint"
        Remove-PnPListItem -List $listname -Identity $listItem.FieldValues.ID | Out-Null
    }
}


