// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package logs

import (
	"fmt"
	"strings"

	"github.com/MakeNowJust/heredoc"

	"github.com/spf13/cobra"
)

var supportedDeploymentModes = []string{"monolithic-mode", "read-write-mode", "microservices-mode"}
var mode string

func NewCmdLogs() *cobra.Command {
	var logsCmd = &cobra.Command{
		Short: "Run Loki for Logs.",
		Use:   "logs",
		Example: heredoc.Doc(`
			# Start up logs in monolithic-mode
			$ lgtmp up logs

			# Start up logs in microservices-mode
			$ lgtmp up logs --mode microservices-mode
		`),

		RunE: func(cmd *cobra.Command, _ []string) error {
			// TODO(qc)
			action := cmd.Parent().Use
			fullCmd := fmt.Sprintf("%s-%s-logs", action, mode)
			fmt.Printf("🔥\x1b[91m make %s \x1b[39m\n", fullCmd)

			if err := cmd.Help(); err != nil {
				return err
			}
			return nil
		},
	}

	logsCmd.Flags().StringVarP(&mode, "mode", "m", "monolithic-mode",
		fmt.Sprintf("deployment mode for logs. Supported modes are: %s.", strings.Join(supportedDeploymentModes, ", ")))

	return logsCmd
}
