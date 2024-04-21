# Auto generated binary variables helper managed by https://github.com/bwplotka/bingo v0.9. DO NOT EDIT.
# All tools are designed to be build inside $GOBIN.
BINGO_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
GOPATH ?= $(shell go env GOPATH)
GOBIN  ?= $(firstword $(subst :, ,${GOPATH}))/bin
GO     ?= $(shell which go)

# Below generated variables ensure that every time a tool under each variable is invoked, the correct version
# will be used; reinstalling only if needed.
# For example for copyright variable:
#
# In your main Makefile (for non array binaries):
#
#include .bingo/Variables.mk # Assuming -dir was set to .bingo .
#
#command: $(COPYRIGHT)
#	@echo "Running copyright"
#	@$(COPYRIGHT) <flags/args..>
#
COPYRIGHT := $(GOBIN)/copyright-v0.0.0-20230505153745-6b7392939a60
$(COPYRIGHT): $(BINGO_DIR)/copyright.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/copyright-v0.0.0-20230505153745-6b7392939a60"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=copyright.mod -o=$(GOBIN)/copyright-v0.0.0-20230505153745-6b7392939a60 "github.com/efficientgo/tools/copyright"

GORELEASER := $(GOBIN)/goreleaser-v1.25.1
$(GORELEASER): $(BINGO_DIR)/goreleaser.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/goreleaser-v1.25.1"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=goreleaser.mod -o=$(GOBIN)/goreleaser-v1.25.1 "github.com/goreleaser/goreleaser"

JB := $(GOBIN)/jb-v0.5.1
$(JB): $(BINGO_DIR)/jb.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/jb-v0.5.1"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=jb.mod -o=$(GOBIN)/jb-v0.5.1 "github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb"

JSONNETFMT := $(GOBIN)/jsonnetfmt-v0.20.0
$(JSONNETFMT): $(BINGO_DIR)/jsonnetfmt.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/jsonnetfmt-v0.20.0"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=jsonnetfmt.mod -o=$(GOBIN)/jsonnetfmt-v0.20.0 "github.com/google/go-jsonnet/cmd/jsonnetfmt"

KUSTOMIZE := $(GOBIN)/kustomize-v5.4.1
$(KUSTOMIZE): $(BINGO_DIR)/kustomize.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/kustomize-v5.4.1"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=kustomize.mod -o=$(GOBIN)/kustomize-v5.4.1 "sigs.k8s.io/kustomize/kustomize/v5"

MIXTOOL := $(GOBIN)/mixtool-v0.0.0-20240408085510-16dc166166d9
$(MIXTOOL): $(BINGO_DIR)/mixtool.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/mixtool-v0.0.0-20240408085510-16dc166166d9"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=mixtool.mod -o=$(GOBIN)/mixtool-v0.0.0-20240408085510-16dc166166d9 "github.com/monitoring-mixins/mixtool/cmd/mixtool"

UPDATECLI := $(GOBIN)/updatecli-v0.75.0
$(UPDATECLI): $(BINGO_DIR)/updatecli.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/updatecli-v0.75.0"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=updatecli.mod -o=$(GOBIN)/updatecli-v0.75.0 "github.com/updatecli/updatecli"

