// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package main

import (
	"fmt"
	"os"

	"github.com/qclaogui/codelab-monitoring/pkg/cmd"
)

// Example:
//
//	go run cmd/lgtmp/main.go up metrics
//	go run cmd/lgtmp/main.go up metrics --mode microservices-mode

func main() {
	rootCmd := cmd.NewCmdRoot()
	if err := rootCmd.Execute(); err != nil {
		fmt.Print(err)
		os.Exit(1)
	}
}
