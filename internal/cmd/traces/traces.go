// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package traces

import (
	"fmt"
	"strings"

	"github.com/MakeNowJust/heredoc"
	"github.com/qclaogui/codelab-monitoring/internal"

	"github.com/spf13/cobra"
)

var supportedDeploymentModes = []string{"monolithic-mode", "microservices-mode"}
var mode string

func NewCmdTraces() *cobra.Command {
	var tracesCmd = &cobra.Command{
		Short: "Run Tempo for Traces.",
		Use:   "traces",
		Example: heredoc.Doc(`
			# Start up traces in monolithic-mode
			$ lgtmp up traces

			# Start up traces in microservices-mode
			$ lgtmp up traces --mode microservices-mode
		`),

		RunE: func(cmd *cobra.Command, _ []string) error {
			// up-monolithic-mode-traces                Run monolithic-mode traces
			// deploy-monolithic-mode-traces            Deploy monolithic-mode traces
			action := cmd.Parent().Use
			target := fmt.Sprintf("%s-%s-traces", action, mode)
			if err := internal.ExecuteCommand("make", "-C", ".", target); err != nil {
				return err
			}
			return nil
		},
	}

	tracesCmd.Flags().StringVarP(&mode, "mode", "m", "monolithic-mode",
		fmt.Sprintf("deployment mode for traces. Supported modes are: %s.", strings.Join(supportedDeploymentModes, ", ")))

	return tracesCmd
}
