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

//go:embed gen.tar
var DirFS embed.FS

//go:generate tar cf gen.tar .bingo docker-compose kubernetes monitoring-mixins tools Makefile
var GenDir = "gen"

func EmbedFsToGenDirectory() error {
	if err := os.MkdirAll(GenDir, 0700); err != nil {
		return err
	}
	r, err := DirFS.Open("gen.tar")
	if err != nil {
		return err
	}
	defer func() { _ = r.Close() }()

	tr := tar.NewReader(r)
	for {
		hdr, trErr := tr.Next()
		if errors.Is(trErr, io.EOF) {
			break
		}
		if trErr != nil {
			return trErr
		}
		target := filepath.Join(GenDir, strings.TrimPrefix(hdr.Name, string(filepath.Separator)))

		info := hdr.FileInfo()
		if info.IsDir() {
			if err = os.MkdirAll(target, 0777); err != nil {
				return err
			}
			continue
		}

		w, openErr := os.OpenFile(target, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, 0666|info.Mode()&0777)
		if openErr != nil {
			return openErr
		}

		if _, ioErr := io.Copy(w, tr); ioErr != nil {
			_ = w.Close()
			return fmt.Errorf("copying %s: %v", target, ioErr)
		}
		if err = w.Close(); err != nil {
			return err
		}
	}
	return nil
}
