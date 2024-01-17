// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package metrics

import (
	"fmt"
	"strings"

	"github.com/MakeNowJust/heredoc"
	"github.com/qclaogui/codelab-monitoring/internal"

	"github.com/spf13/cobra"
)

var supportedDeploymentModes = []string{"monolithic-mode", "read-write-mode", "microservices-mode"}
var mode string

func NewCmdMetrics() *cobra.Command {
	var metricsCmd = &cobra.Command{
		Short: "Run Mimir for Metrics.",
		Use:   "metrics",
		Example: heredoc.Doc(`
			# Start up metrics in monolithic-mode
			$ lgtmp up metrics

			# Start up metrics in microservices-mode
			$ lgtmp up metrics --mode microservices-mode
		`),

		RunE: func(cmd *cobra.Command, _ []string) error {
			// up-monolithic-mode-metrics                Run monolithic-mode metrics
			// deploy-monolithic-mode-metrics            Deploy monolithic-mode metrics
			action := cmd.Parent().Use
			target := fmt.Sprintf("%s-%s-metrics", action, mode)
			if err := internal.ExecuteCommand("make", "-C", ".", target); err != nil {
				return err
			}
			return nil
		},
	}

	metricsCmd.Flags().StringVarP(&mode, "mode", "m", "monolithic-mode",
		fmt.Sprintf("deployment mode for metrics. Supported modes are: %s.", strings.Join(supportedDeploymentModes, ", ")))

	return metricsCmd
}
