// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package cmd

import (
	"fmt"

	"github.com/MakeNowJust/heredoc"
	"github.com/qclaogui/codelab-monitoring/pkg/version"
	"github.com/spf13/cobra"
)

// NewCmdVersion represents the version command
func NewCmdVersion() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "version",
		Short: "Output the version of lgtmp",
		Example: heredoc.Doc(`
			$ lgtmp version
		`),
		RunE: func(_ *cobra.Command, _ []string) error {
			fmt.Printf("%s\n", version.PrintVersion())
			return nil
		},
	}

	return cmd
}
