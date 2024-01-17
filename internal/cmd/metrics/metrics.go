// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package metrics

import (
	"fmt"
	"os"
	"os/exec"
	"os/signal"
	"strings"
	"syscall"

	"github.com/MakeNowJust/heredoc"

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
			action := cmd.Parent().Use
			target := fmt.Sprintf("%s-%s-metrics", action, mode)

			command := exec.Command("make", "-C", ".", target)
			command.Stderr = os.Stderr
			command.Stdout = os.Stdout
			err := command.Start()
			if err != nil {
				return err
			}
			if action == "down" || action == "delete" {
				err := command.Wait()
				if err != nil {
					return err
				}
			} else {
				signalChan := make(chan os.Signal, 1)
				signal.Notify(signalChan, os.Interrupt, syscall.SIGTERM)

				done := make(chan error, 1)
				go func() { done <- command.Wait() }()

				select {
				case <-signalChan:
					fmt.Printf("Received interrupt signal, stopping %s...\n", target)
					_ = command.Process.Signal(os.Interrupt)
					select {
					case <-signalChan:
						fmt.Printf("Forcefully stopping %s...\n", target)
						_ = command.Process.Kill()
						os.Exit(1) // Exit with a status code of 1
					case <-done:
						os.Exit(0) // Exit with a status code of 0
					}
				case err := <-done:
					if err != nil {
						os.Exit(1) // Exit with a status code of 1 upon failure
					}
				}
			}
			return nil
		},
	}

	metricsCmd.Flags().StringVarP(&mode, "mode", "m", "monolithic-mode",
		fmt.Sprintf("deployment mode for metrics. Supported modes are: %s.", strings.Join(supportedDeploymentModes, ", ")))

	return metricsCmd
}
