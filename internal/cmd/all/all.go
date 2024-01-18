// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package all

import (
	"fmt"
	"slices"
	"strings"

	"github.com/MakeNowJust/heredoc"
	"github.com/qclaogui/codelab-monitoring/internal"

	"github.com/spf13/cobra"
)

var supportedModes = []string{"monolithic-mode"}
var mode string

func NewCmdAll() *cobra.Command {
	var allCmd = &cobra.Command{
		Short: "Run Grafana LGTMP Stack All-in-one.",
		Use:   "all",
		Example: heredoc.Doc(`
			# Start up all in monolithic-mode
			$ lgtmp up all

			# Start up all in microservices-mode
			$ lgtmp up all --mode microservices-mode
		`),

		RunE: func(cmd *cobra.Command, _ []string) error {
			if !slices.Contains(supportedModes, mode) {
				return fmt.Errorf("unsupported mode: %s", mode)
			}

			// up-monolithic-mode-all-in-one                Run monolithic-mode all-in-one
			// deploy-monolithic-mode-all-in-one            Deploy monolithic-mode all-in-one
			action := cmd.Parent().Use
			target := fmt.Sprintf("%s-%s-all-in-one", action, mode)
			if err := internal.ExecuteCommand("make", "-C", ".", target); err != nil {
				return err
			}
			return nil
		},
	}

	allCmd.Flags().StringVarP(&mode, "mode", "m", "monolithic-mode",
		fmt.Sprintf("deployment mode for all-in-one. Supported modes are: %s.", strings.Join(supportedModes, ", ")))

	return allCmd
}
