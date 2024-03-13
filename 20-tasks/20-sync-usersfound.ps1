<#---
title: Sync Users Found to SharePoint
connection: sharepoint
---
#>

param ($domain = "pep.pl")

<#
Load file data and connect to SharePoint
#>
$users = Get-Content "$env:WORKDIR/users.found.json" | ConvertFrom-Json

Connect-PnPOnline -Url $ENV:SITEURL  -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"
$listname = "Guests $domain"
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
write-host "Users in list: $($listItems.Count)"

foreach ($listItem in $listItems) {

    
    $sharePointItems.Add($listItem.FieldValues.Title, @{
            id             = $listItem.FieldValues.ID
            Title          = $listItem.FieldValues.Title
            UPN            = $listItem.FieldValues.UPN
            AccountEnabled = $listItem.FieldValues.AccountEnabled
            UserState      = $listItem.FieldValues.UserState
            UserType       = $listItem.FieldValues.UserType
        })
}

<#
Iterate over the users and compare with SharePoint

If the user is in SharePoint, check if the data is different and update if necessary.

If the user is not in SharePoint, add it

#>

write-host "Users in file: $($users.Count)"
foreach ($user in $users) {
    
    $usersInFile.Add($user.Mail, $user.ObjectId)

    if ($sharePointItems.ContainsKey($user.Mail)) {
        # write-host "User $($user.Mail) already in SharePoint"
        if ($user.AccountEnabled -ne $sharePointItems[$user.Mail].AccountEnabled -or $user.UserState -ne $sharePointItems[$user.Mail].UserState -or $user.UserType -ne $sharePointItems[$user.Mail].UserType) {
            write-host "Updating $($user.Mail) in SharePoint"
            Set-PnPListItem -List $listname -Identity $sharePointItems[$user.Mail].id -Values @{
                "AccountEnabled" = $user.AccountEnabled 
                "UserState"      = $user.UserState
                "UserType"       = $user.UserType
            } | Out-Null
        }
        
    }
    else {
        write-host "Adding $($user.Mail) to SharePoint"
        Add-PnPListItem -List $listname -Values @{
            "Title"          = $user.Mail
            "UPN"            = $user.UserPrincipalName
            "AccountEnabled" = $user.AccountEnabled 
            "UserState"      = $user.UserState
            "UserType"       = $user.UserType
           
        
        } | Out-Null
    }
}


<#

Iterate over the SharePoint items and remove the ones that are not in the file
#>

foreach ($listItem in $listItems) {
    if (-not $usersInFile.ContainsKey($listItem.FieldValues.Title)) {
        write-host "Removing $($listItem.FieldValues.Title) from SharePoint"
        Remove-PnPListItem -List $listname -Identity $listItem.FieldValues.ID | Out-Null
    }
}


