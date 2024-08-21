// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package traces

import (
	"fmt"
	"slices"
	"strings"

	"github.com/MakeNowJust/heredoc"
	"github.com/qclaogui/codelab-monitoring/pkg"
	"github.com/spf13/cobra"
)

var (
	supportedModes = []string{"monolithic-mode", "microservices-mode"}
	mode           string
)

func NewCmdTraces() *cobra.Command {
	tracesCmd := &cobra.Command{
		Short: "Run Tempo for Traces.",
		Use:   "traces",
		Example: heredoc.Doc(`
			# Start up traces in monolithic-mode
			$ lgtmp up traces

			# Start up traces in microservices-mode
			$ lgtmp up traces --mode microservices-mode
		`),

		RunE: func(cmd *cobra.Command, _ []string) error {
			if !slices.Contains(supportedModes, mode) {
				return fmt.Errorf("unsupported mode: %s", mode)
			}

			// up-monolithic-mode-traces                Run monolithic-mode traces
			// deploy-monolithic-mode-traces            Deploy monolithic-mode traces
			action := cmd.Parent().Use
			target := fmt.Sprintf("%s-%s-traces", action, mode)
			if err := pkg.ExecuteCommand("make", "-C", ".", target); err != nil {
				return err
			}
			return nil
		},
	}

	tracesCmd.Flags().StringVarP(&mode, "mode", "m", "monolithic-mode",
		fmt.Sprintf("deployment mode for traces. Supported modes are: %s.", strings.Join(supportedModes, ", ")))

	return tracesCmd
}
