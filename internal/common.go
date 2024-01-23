// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package internal

import (
	"fmt"
	"os"
	"os/exec"
	"os/signal"
	"runtime"
	"strings"
	"syscall"
	"time"
)

func ExecuteCommand(command string, args ...string) error {
	cmd := exec.Command(command, args...)
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout
	if err := cmd.Start(); err != nil {
		return err
	}

	target := args[len(args)-1]
	if strings.HasPrefix(target, "down-") || strings.HasPrefix(target, "delete-") {
		if err := cmd.Wait(); err != nil {
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
			browser(target)
		}
	}

	return nil
}

func browser(target string) {
	if strings.HasPrefix(target, "up-") {
		OpenBrowser("http://localhost:3000/explore")
	} else if strings.HasPrefix(target, "deploy-") {
		OpenBrowser("http://localhost:8080/explore")
	}
	return
}

// openArgs returns a list of possible args to use to open a url.
func openArgs() []string {
	var cmds []string
	switch runtime.GOOS {
	case "darwin":
		cmds = []string{"/usr/bin/open"}
	case "windows":
		cmds = []string{"cmd", "/c", "start"}
	default:
		if os.Getenv("DISPLAY") != "" {
			// xdg-open is only for use in a desktop environment.
			cmds = []string{"xdg-open"}
		}
	}

	return cmds
}

// OpenBrowser tries to open url in a browser and reports whether it succeeded.
func OpenBrowser(url string) bool {
	args := openArgs()
	cmd := exec.Command(args[0], append(args[1:], url)...)
	if cmd.Start() == nil && appearsSuccessful(cmd, 5*time.Second) {
		return true
	}
	return false
}

// appearsSuccessful reports whether the command appears to have run successfully.
// If the command runs longer than the timeout, it's deemed successful.
// If the command runs within the timeout, it's deemed successful if it exited cleanly.
func appearsSuccessful(cmd *exec.Cmd, timeout time.Duration) bool {
	errc := make(chan error, 1)
	go func() { errc <- cmd.Wait() }()

	select {
	case <-time.After(timeout):
		return true
	case err := <-errc:
		return err == nil
	}
}
