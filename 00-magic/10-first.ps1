<#---
title: Refresh PEP.PL users
tag: pep.pl
icon: magic.png
---

#>

koksmat trace log "Finding users with external emails from pep.pl"

azure-users azuread find-users pep.pl

koksmat trace log "Syncronizing with list"

azure-users tasks sync-guests pep.pl
