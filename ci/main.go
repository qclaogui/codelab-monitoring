package main

import (
	"context"
	"os"

	"dagger.io/dagger"
)

// use golang:1.20.6 container as builder
const goImage = "golang:1.20.6"

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
		WithMountedDirectory("/app", source).
		WithWorkdir("/app")

	// Install dependencies tools
	if _, err = goContainer.WithExec([]string{"bash", "-c", "make", "install-build-deps"}).Sync(ctx); err != nil {
		panic(err)
	}

	// check dashboards
	if _, err = goContainer.WithExec([]string{"bash", "-c", "make", "check"}).Sync(ctx); err != nil {
		panic(err)
	}

	// dashboards out
	if _, err = goContainer.WithExec([]string{"bash", "-c", "make", "dashboards_out"}).Sync(ctx); err != nil {
		panic(err)
	}

}
