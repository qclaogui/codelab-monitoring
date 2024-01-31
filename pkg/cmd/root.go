// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package cmd

import (
	"github.com/MakeNowJust/heredoc"
	"github.com/spf13/cobra"
)

// NewCmdRoot represents the base command when called without any subcommands
func NewCmdRoot() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "lgtmp <command> <subcommand> [flags]",
		Short: "LGTMP CLI",
		Long: heredoc.Doc(`
			Grafana LGTMP Stack from the command line
			L -> Loki	Like Prometheus, but for logs
			G -> Grafana	The open and composable observability and data visualization platform
			T -> Tempo	A high volume, minimal dependency distributed tracing backend
			M -> Mimir	The most scalable Prometheus backend
			P -> Pyroscope	Continuous Profiling Platform. Debug performance issues down to a single line of code
		`),

		Example: heredoc.Doc(`
			$ lgtmp up metrics
		`),
	}

	cmd.PersistentFlags().BoolP("help", "h", false, "Show help for command")

	// Child commands provisioning by Docker Compose
	cmd.AddCommand(NewCmdUp())
	cmd.AddCommand(NewCmdDown())

	// Child commands provisioning by Kubernetes
	cmd.AddCommand(NewCmdDeploy())
	cmd.AddCommand(NewCmdDelete())

	// Version command
	cmd.AddCommand(NewCmdVersion())

	return cmd
}
