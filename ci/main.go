// Copyright © Weifeng Wang <qclaogui@gmail.com>
//
// Licensed under the Apache License 2.0.

package main

import (
	"context"
	"os"

	"dagger.io/dagger"
)

const goImage = "golang:1.23.1"

func main() {
	println("Dagger is a programmable CI/CD engine that runs your pipelines in containers.")

	ctx := context.Background()

	// initialize Dagger client
	client, err := dagger.Connect(ctx, dagger.WithLogOutput(os.Stderr))
	if err != nil {
		panic(err)
	}
	defer func() { _ = client.Close() }()

	// source code directory
	source := client.Host().Directory(".")

	// use golang container as base
	goContainer := client.Container().From(goImage).
		WithMountedCache("/go/pkg/mod", client.CacheVolume("go-mod")).
		WithMountedCache("/root/.cache/go-build", client.CacheVolume("go-build")).
		WithEnvVariable("GOCACHE", "/root/.cache/go-build").
		WithMountedDirectory("/workspace", source).
		WithWorkdir("/workspace")

	// Install dependencies tools
	if _, err = goContainer.WithExec([]string{"make", "install-build-deps"}).Sync(ctx); err != nil {
		panic(err)
	}
}
