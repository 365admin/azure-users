// -------------------------------------------------------------------
// Generated by 365admin-publish/api/20 makeschema.ps1
// -------------------------------------------------------------------
/*
---
title: Core Version
---
*/
package endpoints

import (
	"context"

	"github.com/swaggest/usecase"

	"github.com/365admin/azure-users/execution"
)

func HealthCoreversionPost() usecase.Interactor {
	type Request struct {
	}
	u := usecase.NewInteractor(func(ctx context.Context, input Request, output *string) error {

		_, err := execution.ExecutePowerShell("john", "*", "azure-users", "00-health", "20-coreversion.ps1", "")
		if err != nil {
			return err
		}

		return err

	})
	u.SetTitle("Core Version")
	// u.SetExpectedErrors(status.InvalidArgument)
	u.SetTags("Health")
	return u
}
