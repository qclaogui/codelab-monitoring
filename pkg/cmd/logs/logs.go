// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package logs

import (
	"fmt"
	"slices"
	"strings"

	"github.com/MakeNowJust/heredoc"
	"github.com/qclaogui/codelab-monitoring/pkg"
	"github.com/spf13/cobra"
)

var (
	supportedModes = []string{"monolithic-mode", "read-write-mode", "microservices-mode"}
	mode           string
)

func NewCmdLogs() *cobra.Command {
	logsCmd := &cobra.Command{
		Short: "Run Loki for Logs.",
		Use:   "logs",
		Example: heredoc.Doc(`
			# Start up logs in monolithic-mode
			$ lgtmp up logs

			# Start up logs in microservices-mode
			$ lgtmp up logs --mode microservices-mode
		`),

		RunE: func(cmd *cobra.Command, _ []string) error {
			if !slices.Contains(supportedModes, mode) {
				return fmt.Errorf("unsupported mode: %s", mode)
			}

			// up-monolithic-mode-logs                Run monolithic-mode logs
			// deploy-monolithic-mode-logs            Deploy monolithic-mode logs
			action := cmd.Parent().Use
			target := fmt.Sprintf("%s-%s-logs", action, mode)
			if err := pkg.ExecuteCommand("make", "-C", ".", target); err != nil {
				return err
			}
			return nil
		},
	}

	logsCmd.Flags().StringVarP(&mode, "mode", "m", "monolithic-mode",
		fmt.Sprintf("deployment mode for logs. Supported modes are: %s.", strings.Join(supportedModes, ", ")))

	return logsCmd
}
