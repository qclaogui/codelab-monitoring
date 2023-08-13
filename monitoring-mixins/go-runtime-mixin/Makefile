.DEFAULT_GOAL := help

include ../../.bingo/Variables.mk

# path to jsonnetfmt
JSONNET_FMT := $(JSONNETFMT) -n 2 --max-blank-lines 2 --string-style s --comment-style s
# path to the mixin
MIXIN_OUT_PATH := deploy

.PHONY: fmt
fmt: ## Format the mixin files
	@find . -type f -name '*.libsonnet' | xargs -n 1 -- $(JSONNET_FMT) -i

.PHONY: build
build: ## Generates the mixin files
	@mkdir -p "$(MIXIN_OUT_PATH)"; \
	find "$(MIXIN_OUT_PATH)" ! -name "kustomization.yaml" -type f -delete; \
	$(MIXTOOL) generate all --output-alerts "$(MIXIN_OUT_PATH)/alerts.yaml" --output-rules "$(MIXIN_OUT_PATH)/rules.yaml" --directory "$(MIXIN_OUT_PATH)/dashboards_out" "mixin.libsonnet"; \
	#../../tools/check-rules.sh "$(MIXIN_OUT_PATH)/rules.yaml" 20 ; \

.PHONY: check
check: build fmt ## Build, fmt and check the mixin files
	@../../tools/find-diff-or-untracked.sh . "$(MIXIN_OUT_PATH)" || (echo "Please build and fmt mixin by running 'make build fmt'" && false); \
	# jb install && \
	# $(MIXTOOL) lint mixin.libsonnet

##@ Dashboards & k8s

.PHONY: manifests
manifests: $(KUSTOMIZE) ## Generates dashboards for k8s
	$(KUSTOMIZE) build deploy > deploy/manifests/k8s-all-in-one.yaml

.PHONY: rules_load
rules_load: ## Load rules and alerts to monitoring system
	mimirtool rules load --id=anonymous --address=http://localhost:9009 deploy/rules.yaml
	mimirtool rules load --id=anonymous --address=http://localhost:9009 deploy/alerts.yaml
	# am
	#mimirtool alertmanager --id=anonymous --address=http://localhost:9009 load deploy/alertmanager.yaml deploy/default.tmpl
	#mimirtool alertmanager --id=anonymous --address=http://localhost:9009 get
	#mimirtool alertmanager --id=anonymous --address=http://localhost:9009 delete

##@ General

.PHONY: help
help:  ## Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/
ifeq ($(OS),Windows_NT)
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-40s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
else
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
endif
