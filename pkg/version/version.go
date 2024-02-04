// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package version

import (
	"fmt"
	"strings"
)

//go:generate go run ./release_generate.go

// ExtraSep separates semver version from any extra version info
const ExtraSep = "-"

// GetVersion return the exact version of this build
func GetVersion() string {
	if PreReleaseID == "" {
		return Version
	}

	versionWithPR := fmt.Sprintf("%s%s%s", Version, ExtraSep, PreReleaseID)

	if isReleaseCandidate(PreReleaseID) || (GitCommit == "" || BuildDate == "") {
		return versionWithPR
	}

	//  Include build metadata
	return fmt.Sprintf("%s+%s.%s",
		versionWithPR,
		GitCommit,
		BuildDate,
	)
}

func isReleaseCandidate(preReleaseID string) bool {
	return strings.HasPrefix(preReleaseID, "rc.")
}

func PrintVersion() string {
	return fmt.Sprintf("lgtmp has version %s built with %s from %s on %s\n",
		Version, GoVersion, GitCommit, BuildDate)
}
