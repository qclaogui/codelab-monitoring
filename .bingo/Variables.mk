# Auto generated binary variables helper managed by https://github.com/bwplotka/bingo v0.9. DO NOT EDIT.
# All tools are designed to be build inside $GOBIN.
BINGO_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
GOPATH ?= $(shell go env GOPATH)
GOBIN  ?= $(firstword $(subst :, ,${GOPATH}))/bin
GO     ?= $(shell which go)

# Below generated variables ensure that every time a tool under each variable is invoked, the correct version
# will be used; reinstalling only if needed.
# For example for cmctl variable:
#
# In your main Makefile (for non array binaries):
#
#include .bingo/Variables.mk # Assuming -dir was set to .bingo .
#
#command: $(CMCTL)
#	@echo "Running cmctl"
#	@$(CMCTL) <flags/args..>
#
CMCTL := $(GOBIN)/cmctl-v2.1.1
$(CMCTL): $(BINGO_DIR)/cmctl.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/cmctl-v2.1.1"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=cmctl.mod -o=$(GOBIN)/cmctl-v2.1.1 "github.com/cert-manager/cmctl/v2"

COPYRIGHT := $(GOBIN)/copyright-v0.0.0-20230505153745-6b7392939a60
$(COPYRIGHT): $(BINGO_DIR)/copyright.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/copyright-v0.0.0-20230505153745-6b7392939a60"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=copyright.mod -o=$(GOBIN)/copyright-v0.0.0-20230505153745-6b7392939a60 "github.com/efficientgo/tools/copyright"

GOFUMPT := $(GOBIN)/gofumpt-v0.7.0
$(GOFUMPT): $(BINGO_DIR)/gofumpt.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/gofumpt-v0.7.0"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=gofumpt.mod -o=$(GOBIN)/gofumpt-v0.7.0 "mvdan.cc/gofumpt"

GOIMPORTS := $(GOBIN)/goimports-v0.29.0
$(GOIMPORTS): $(BINGO_DIR)/goimports.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/goimports-v0.29.0"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=goimports.mod -o=$(GOBIN)/goimports-v0.29.0 "golang.org/x/tools/cmd/goimports"

GOLANGCI_LINT := $(GOBIN)/golangci-lint-v1.63.4
$(GOLANGCI_LINT): $(BINGO_DIR)/golangci-lint.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/golangci-lint-v1.63.4"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=golangci-lint.mod -o=$(GOBIN)/golangci-lint-v1.63.4 "github.com/golangci/golangci-lint/cmd/golangci-lint"

GORELEASER := $(GOBIN)/goreleaser-v1.26.2
$(GORELEASER): $(BINGO_DIR)/goreleaser.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/goreleaser-v1.26.2"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=goreleaser.mod -o=$(GOBIN)/goreleaser-v1.26.2 "github.com/goreleaser/goreleaser"

GRR := $(GOBIN)/grr-v0.6.1
$(GRR): $(BINGO_DIR)/grr.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/grr-v0.6.1"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=grr.mod -o=$(GOBIN)/grr-v0.6.1 "github.com/grafana/grizzly/cmd/grr"

JB := $(GOBIN)/jb-v0.6.0
$(JB): $(BINGO_DIR)/jb.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/jb-v0.6.0"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=jb.mod -o=$(GOBIN)/jb-v0.6.0 "github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb"

JSONNETFMT := $(GOBIN)/jsonnetfmt-v0.20.0
$(JSONNETFMT): $(BINGO_DIR)/jsonnetfmt.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/jsonnetfmt-v0.20.0"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=jsonnetfmt.mod -o=$(GOBIN)/jsonnetfmt-v0.20.0 "github.com/google/go-jsonnet/cmd/jsonnetfmt"

K3D := $(GOBIN)/k3d-v5.7.5
$(K3D): $(BINGO_DIR)/k3d.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/k3d-v5.7.5"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=k3d.mod -o=$(GOBIN)/k3d-v5.7.5 "github.com/k3d-io/k3d/v5"

KUSTOMIZE := $(GOBIN)/kustomize-v5.5.0
$(KUSTOMIZE): $(BINGO_DIR)/kustomize.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/kustomize-v5.5.0"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=kustomize.mod -o=$(GOBIN)/kustomize-v5.5.0 "sigs.k8s.io/kustomize/kustomize/v5"

MIXTOOL := $(GOBIN)/mixtool-v0.0.0-20250106141011-7472b3fc310e
$(MIXTOOL): $(BINGO_DIR)/mixtool.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/mixtool-v0.0.0-20250106141011-7472b3fc310e"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=mixtool.mod -o=$(GOBIN)/mixtool-v0.0.0-20250106141011-7472b3fc310e "github.com/monitoring-mixins/mixtool/cmd/mixtool"

UPDATECLI := $(GOBIN)/updatecli-v0.91.0
$(UPDATECLI): $(BINGO_DIR)/updatecli.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/updatecli-v0.91.0"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=updatecli.mod -o=$(GOBIN)/updatecli-v0.91.0 "github.com/updatecli/updatecli"

