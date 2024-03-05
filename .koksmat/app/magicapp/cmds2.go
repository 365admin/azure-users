package magicapp

import (
	"github.com/spf13/cobra"
)

func RegisterCmds() {
	tasksCmd := &cobra.Command{
		Use:   "tasks",
		Short: "Tasks",
		Long:  `Describe the main purpose of this kitchen`,
	}

	RootCmd.AddCommand(tasksCmd)
	authenticationCmd := &cobra.Command{
		Use:   "authentication",
		Short: "authentication",
		Long:  `Describe the main purpose of this kitchen`,
	}

	RootCmd.AddCommand(authenticationCmd)
}
