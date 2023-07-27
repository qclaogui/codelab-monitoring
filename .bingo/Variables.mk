# Auto generated binary variables helper managed by https://github.com/bwplotka/bingo v0.8. DO NOT EDIT.
# All tools are designed to be build inside $GOBIN.
BINGO_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
GOPATH ?= $(shell go env GOPATH)
GOBIN  ?= $(firstword $(subst :, ,${GOPATH}))/bin
GO     ?= $(shell which go)

# Below generated variables ensure that every time a tool under each variable is invoked, the correct version
# will be used; reinstalling only if needed.
# For example for jsonnetfmt variable:
#
# In your main Makefile (for non array binaries):
#
#include .bingo/Variables.mk # Assuming -dir was set to .bingo .
#
#command: $(JSONNETFMT)
#	@echo "Running jsonnetfmt"
#	@$(JSONNETFMT) <flags/args..>
#
JSONNETFMT := $(GOBIN)/jsonnetfmt-v0.20.0
$(JSONNETFMT): $(BINGO_DIR)/jsonnetfmt.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/jsonnetfmt-v0.20.0"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=jsonnetfmt.mod -o=$(GOBIN)/jsonnetfmt-v0.20.0 "github.com/google/go-jsonnet/cmd/jsonnetfmt"

MIXTOOL := $(GOBIN)/mixtool-v0.0.0-20230702171844-2282201396b6
$(MIXTOOL): $(BINGO_DIR)/mixtool.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/mixtool-v0.0.0-20230702171844-2282201396b6"
	@cd $(BINGO_DIR) && GOWORK=off $(GO) build -mod=mod -modfile=mixtool.mod -o=$(GOBIN)/mixtool-v0.0.0-20230702171844-2282201396b6 "github.com/monitoring-mixins/mixtool/cmd/mixtool"

