<#---
title: Refresh PEP.PL users
tag: pep.pl
icon: magic.png
api: post
---

#>
$domain = "pep.pl"

koksmat trace log "Finding users with external emails from pep.pl"
azure-users azuread find-users $domain

koksmat trace log "Syncronizing with list"
azure-users tasks sync-guests (join-path $env:WORKDIR "users.found.json") $domain
