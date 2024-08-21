// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package cmd

import (
	"github.com/MakeNowJust/heredoc"
	"github.com/qclaogui/codelab-monitoring/pkg/cmd/all"
	"github.com/qclaogui/codelab-monitoring/pkg/cmd/logs"
	"github.com/qclaogui/codelab-monitoring/pkg/cmd/metrics"
	"github.com/qclaogui/codelab-monitoring/pkg/cmd/profiles"
	"github.com/qclaogui/codelab-monitoring/pkg/cmd/traces"
	"github.com/spf13/cobra"
)

func NewCmdUp() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "up",
		Short: "Provisioning Grafana LGTMP stack by Docker Compose",
		Example: heredoc.Doc(`
			# lgtmp up <command>
			$ lgtmp up metrics
		`),
	}

	cmd.AddCommand(all.NewCmdAll())
	cmd.AddCommand(logs.NewCmdLogs())
	cmd.AddCommand(metrics.NewCmdMetrics())
	cmd.AddCommand(profiles.NewCmdProfiles())
	cmd.AddCommand(traces.NewCmdTraces())

	return cmd
}
