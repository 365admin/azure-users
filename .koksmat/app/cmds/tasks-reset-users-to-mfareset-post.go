// -------------------------------------------------------------------
// Generated by 365admin-publish
// -------------------------------------------------------------------
/*
---
title: Report Users to MFA reset
---
*/
package cmds

import (
	"context"
	"os"
	"path"

	"github.com/365admin/azure-users/execution"
	"github.com/365admin/azure-users/utils"
)

func TasksResetUsersToMfaresetPost(ctx context.Context, body []byte, args []string) (*string, error) {
	inputErr := os.WriteFile(path.Join(utils.WorkDir("azure-users"), "users.mfareset.done.json"), body, 0644)
	if inputErr != nil {
		return nil, inputErr
	}

	result, pwsherr := execution.ExecutePowerShell("john", "*", "azure-users", "20-tasks", "10 get-users-to-mfareset.done.ps1", "", "-domain", args[1])
	if pwsherr != nil {
		return nil, pwsherr
	}
	utils.PrintSkip2FirstAnd2LastLines(string(result))
	return nil, nil

}
