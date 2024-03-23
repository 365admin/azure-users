package magicapp

import (
	"github.com/spf13/cobra"
)

func RegisterServiceCmd() {
	natsCmd := &cobra.Command{
		Use:   "service",
		Short: "Start the Micro Service responder",

		Run: func(cmd *cobra.Command, args []string) {
			StartMicroService()
		},
	}
	RootCmd.AddCommand(natsCmd)
}
