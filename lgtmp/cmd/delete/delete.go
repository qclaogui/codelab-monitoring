// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package delete

import (
	"github.com/MakeNowJust/heredoc"
	"github.com/qclaogui/codelab-monitoring/internal/cmd/logs"
	"github.com/qclaogui/codelab-monitoring/internal/cmd/metrics"

	"github.com/spf13/cobra"
)

func NewCmdDelete() *cobra.Command {
	var cmd = &cobra.Command{
		Use:   "delete",
		Short: "Delete LGTMP stack.",
		Long:  "Provisioning LGTMP stack by Kubernetes.",
		Example: heredoc.Doc(`
			# lgtmp delete <command>
			$ lgtmp delete metrics
		`),
	}

	cmd.AddCommand(metrics.NewCmdMetrics())
	cmd.AddCommand(logs.NewCmdLogs())

	return cmd
}
