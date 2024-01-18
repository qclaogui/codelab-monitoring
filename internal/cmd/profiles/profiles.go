// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package profiles

import (
	"fmt"
	"slices"
	"strings"

	"github.com/MakeNowJust/heredoc"
	"github.com/qclaogui/codelab-monitoring/internal"

	"github.com/spf13/cobra"
)

var supportedModes = []string{"monolithic-mode", "microservices-mode"}
var mode string

func NewCmdProfiles() *cobra.Command {
	var profilesCmd = &cobra.Command{
		Short: "Run Pyroscope for Profiles.",
		Use:   "profiles",
		Example: heredoc.Doc(`
			# Start up profiles in monolithic-mode
			$ lgtmp up profiles

			# Start up profiles in microservices-mode
			$ lgtmp up profiles --mode microservices-mode
		`),

		RunE: func(cmd *cobra.Command, _ []string) error {
			if !slices.Contains(supportedModes, mode) {
				return fmt.Errorf("unsupported mode: %s", mode)
			}

			// up-monolithic-mode-profiles                Run monolithic-mode profiles
			// deploy-monolithic-mode-profiles            Deploy monolithic-mode profiles
			action := cmd.Parent().Use
			target := fmt.Sprintf("%s-%s-profiles", action, mode)
			if err := internal.ExecuteCommand("make", "-C", ".", target); err != nil {
				return err
			}
			return nil
		},
	}

	profilesCmd.Flags().StringVarP(&mode, "mode", "m", "monolithic-mode",
		fmt.Sprintf("deployment mode for profiles. Supported modes are: %s.", strings.Join(supportedModes, ", ")))

	return profilesCmd
}
