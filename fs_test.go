// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package source

import "testing"

func TestDockerComposeFS(t *testing.T) {
	// run go generate
	if _, err := DirFS.Open(".lgtmp.tar"); err != nil {
		t.Errorf("\nOops 🔥\x1b[91m Failed asserting that\x1b[39m\n"+
			"✘got: %v\n\x1b[92m"+
			"want: %v\x1b[39m", err, nil)
	}
}
