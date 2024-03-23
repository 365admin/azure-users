package magicapp

import (
	"os"

	"github.com/spf13/cobra"

	"github.com/365admin/azure-users/cmds"
	"github.com/365admin/azure-users/utils"
)

func RegisterCmds() {
	RootCmd.PersistentFlags().StringVarP(&utils.Output, "output", "o", "", "Output format (json, yaml, xml, etc.)")

	healthCmd := &cobra.Command{
		Use:   "health",
		Short: "Health",
		Long:  `Describe the main purpose of this kitchen`,
	}
	HealthPingPostCmd := &cobra.Command{
		Use:   "ping  pong",
		Short: "Ping",
		Long:  `Simple ping endpoint`,
		Args:  cobra.MinimumNArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.HealthPingPost(ctx, args)
		},
	}
	healthCmd.AddCommand(HealthPingPostCmd)
	HealthCoreversionPostCmd := &cobra.Command{
		Use:   "coreversion ",
		Short: "Core Version",
		Long:  ``,
		Args:  cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.HealthCoreversionPost(ctx, args)
		},
	}
	healthCmd.AddCommand(HealthCoreversionPostCmd)

	RootCmd.AddCommand(healthCmd)
	tasksCmd := &cobra.Command{
		Use:   "tasks",
		Short: "Tasks",
		Long:  `Describe the main purpose of this kitchen`,
	}
	TasksGetUsersToMfaresetPostCmd := &cobra.Command{
		Use:   "get-users-to-mfareset  domain",
		Short: "Get Users to MFA reset",
		Long:  ``,
		Args:  cobra.MinimumNArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.TasksGetUsersToMfaresetPost(ctx, args)
		},
	}
	tasksCmd.AddCommand(TasksGetUsersToMfaresetPostCmd)
	TasksResetUsersToMfaresetPostCmd := &cobra.Command{
		Use:   "reset-users-to-mfareset  domain",
		Short: "Report Users to MFA reset",
		Long:  ``,
		Args:  cobra.MinimumNArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()
			body, err := os.ReadFile(args[0])
			if err != nil {
				panic(err)
			}

			cmds.TasksResetUsersToMfaresetPost(ctx, body, args)
		},
	}
	tasksCmd.AddCommand(TasksResetUsersToMfaresetPostCmd)

	RootCmd.AddCommand(tasksCmd)
	azureadCmd := &cobra.Command{
		Use:   "azuread",
		Short: "Azure AD",
		Long:  `Describe the main purpose of this kitchen`,
	}
	AzureadResetMfaPostCmd := &cobra.Command{
		Use:   "reset-mfa ",
		Short: "Reset MFA",
		Long:  ``,
		Args:  cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()
			body, err := os.ReadFile(args[0])
			if err != nil {
				panic(err)
			}

			cmds.AzureadResetMfaPost(ctx, body, args)
		},
	}
	azureadCmd.AddCommand(AzureadResetMfaPostCmd)

	RootCmd.AddCommand(azureadCmd)
	deploywebCmd := &cobra.Command{
		Use:   "deployweb",
		Short: "Deploy Web",
		Long:  `Describe the main purpose of this kitchen`,
	}
	DeploywebWebdeployproductionPostCmd := &cobra.Command{
		Use:   "webdeployproduction ",
		Short: "Web deploy to production",
		Long:  ``,
		Args:  cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.DeploywebWebdeployproductionPost(ctx, args)
		},
	}
	deploywebCmd.AddCommand(DeploywebWebdeployproductionPostCmd)

	RootCmd.AddCommand(deploywebCmd)
	provisionCmd := &cobra.Command{
		Use:   "provision",
		Short: "Provision",
		Long:  `Describe the main purpose of this kitchen`,
	}
	ProvisionWebdeployproductionPostCmd := &cobra.Command{
		Use:   "webdeployproduction ",
		Short: "Web deploy to production",
		Long:  ``,
		Args:  cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.ProvisionWebdeployproductionPost(ctx, args)
		},
	}
	provisionCmd.AddCommand(ProvisionWebdeployproductionPostCmd)

	RootCmd.AddCommand(provisionCmd)
	authCmd := &cobra.Command{
		Use:   "auth",
		Short: "Authentication",
		Long:  `Describe the main purpose of this kitchen`,
	}
	AuthEnableDisabledPostCmd := &cobra.Command{
		Use:   "enable-disabled  domain",
		Short: "Enable disable users",
		Long:  ``,
		Args:  cobra.MinimumNArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.AuthEnableDisabledPost(ctx, args)
		},
	}
	authCmd.AddCommand(AuthEnableDisabledPostCmd)

	RootCmd.AddCommand(authCmd)
}
