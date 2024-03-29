// -------------------------------------------------------------------
// Generated by 365admin-publish/api/20 makeschema.ps1
// -------------------------------------------------------------------
/*
---
title: Report Users to MFA reset
---
*/
package endpoints

import (
	"context"
	"encoding/json"
	"os"
	"path"

	"github.com/swaggest/usecase"

	"github.com/365admin/azure-users/execution"
	"github.com/365admin/azure-users/schemas"
	"github.com/365admin/azure-users/utils"
)

func TasksResetUsersToMfaresetPost() usecase.Interactor {
	type Request struct {
		Domain string                    `query:"domain" binding:"required"`
		Body   schemas.UsersMfaresetDone `json:"body" binding:"required"`
	}
	u := usecase.NewInteractor(func(ctx context.Context, input Request, output *string) error {
		body, inputErr := json.Marshal(input.Body)
		if inputErr != nil {
			return inputErr
		}

		inputErr = os.WriteFile(path.Join(utils.WorkDir("azure-users"), "users.mfareset.done.json"), body, 0644)
		if inputErr != nil {
			return inputErr
		}

		_, err := execution.ExecutePowerShell("john", "*", "azure-users", "20-tasks", "10 get-users-to-mfareset.done.ps1", "", "-domain", input.Domain)
		if err != nil {
			return err
		}

		return err

	})
	u.SetTitle("Report Users to MFA reset")
	// u.SetExpectedErrors(status.InvalidArgument)
	u.SetTags("Tasks")
	return u
}
