// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package source

import (
	"archive/tar"
	"embed"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
)

//go:generate tar cf .lgtmp.tar .bingo alloy-modules docker-compose kubernetes monitoring-mixins tools Makefile

//go:embed .lgtmp.tar
var DirFS embed.FS

var GenDir = ".lgtmp"

func init() {
	if err := EmbedFsToGenDirectory(); err != nil {
		fmt.Println("Error initializing embedded filesystem:", err)
		os.Exit(1)
	}
}

func EmbedFsToGenDirectory() error {
	if err := os.RemoveAll(GenDir); err != nil {
		return fmt.Errorf("failed to remove existing directory %s: %w", GenDir, err)
	}

	r, err := DirFS.Open(".lgtmp.tar")
	if err != nil {
		return fmt.Errorf("failed to open embedded tar file: %w", err)
	}
	defer func() {
		if closeErr := r.Close(); closeErr != nil {
			fmt.Println("Error closing tar file reader:", closeErr)
		}
	}()

	tr := tar.NewReader(r)
	for {
		hdr, trErr := tr.Next()
		if errors.Is(trErr, io.EOF) {
			break
		}
		if trErr != nil {
			return fmt.Errorf("failed to read next tar header: %w", trErr)
		}

		target := filepath.Join(GenDir, strings.TrimPrefix(hdr.Name, string(filepath.Separator)))
		info := hdr.FileInfo()

		if info.IsDir() {
			if err := os.MkdirAll(target, 0o777); err != nil {
				return fmt.Errorf("failed to create directory %s: %w", target, err)
			}
			continue
		}

		// Ensure the directory for the file exists
		if err := os.MkdirAll(filepath.Dir(target), 0o777); err != nil {
			return fmt.Errorf("failed to create directory %s: %w", filepath.Dir(target), err)
		}

		w, openErr := os.OpenFile(target, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, info.Mode().Perm())
		if openErr != nil {
			return fmt.Errorf("failed to open file %s for writing: %w", target, openErr)
		}

		if _, ioErr := io.Copy(w, tr); ioErr != nil {
			_ = w.Close()
			return fmt.Errorf("failed to copy data to %s: %w", target, ioErr)
		}

		if closeErr := w.Close(); closeErr != nil {
			return fmt.Errorf("failed to close file %s: %w", target, closeErr)
		}
	}
	return nil
}
