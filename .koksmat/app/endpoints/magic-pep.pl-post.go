// -------------------------------------------------------------------
// Generated by 365admin-publish/api/20 makeschema.ps1
// -------------------------------------------------------------------
/*
---
title: Refresh PEP.PL users
---
*/
package endpoints

import (
	"context"

	"github.com/swaggest/usecase"

	"github.com/365admin/azure-users/execution"
)

func MagicPepplPost() usecase.Interactor {
	type Request struct {
	}
	u := usecase.NewInteractor(func(ctx context.Context, input Request, output *string) error {

		_, err := execution.ExecutePowerShell("john", "*", "azure-users", "00-magic", "10-pep.pl-sync.ps1", "")
		if err != nil {
			return err
		}

		return err

	})
	u.SetTitle("Refresh PEP.PL users")
	// u.SetExpectedErrors(status.InvalidArgument)
	u.SetTags("Magic Buttons")
	return u
}
