// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package internal

import (
	"bytes"
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"strings"
	"syscall"
)

func ExecuteCommand(command string, args ...string) error {
	cmd := exec.Command(command, args...)
	var stderr bytes.Buffer
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout
	if err := cmd.Start(); err != nil {
		log.Fatalf("Error: %s\n", stderr.String())
	}

	// make target is the last argment
	target := args[len(args)-1]
	if strings.HasPrefix(target, "down-") || strings.HasPrefix(target, "delete-") {
		err := cmd.Wait()
		if err != nil {
			return err
		}
	} else {
		signalChan := make(chan os.Signal, 1)
		signal.Notify(signalChan, os.Interrupt, syscall.SIGTERM)

		done := make(chan error, 1)
		go func() { done <- cmd.Wait() }()

		select {
		case <-signalChan:
			fmt.Printf("Received interrupt signal, stopping %s...\n", target)
			_ = cmd.Process.Signal(os.Interrupt)
			select {
			case <-signalChan:
				fmt.Printf("Force stopping %s...\n", target)
				_ = cmd.Process.Kill()
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
}
