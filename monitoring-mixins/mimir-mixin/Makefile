.DEFAULT_GOAL := help

include ../../.bingo/Variables.mk

# path to jsonnetfmt
JSONNET_FMT := $(JSONNETFMT) -n 2 --max-blank-lines 2 --string-style s --comment-style s
# path to the mixin
MIXIN_OUT_PATH := deploy

CURRENT_DIR = $(notdir $(shell pwd))

.PHONY: fmt
fmt: ## Format the mixin files
	@find . -type f -name '*.libsonnet' | xargs -n 1 -- $(JSONNET_FMT) -i

.PHONY: update
update: $(JB) ## update mixin 
	$(JB) update

define build_mixin_func
	$(eval $@_MIXIN_OUTPUT = $(1))
	@mkdir -p "${$@_MIXIN_OUTPUT}"; \
	find "${$@_MIXIN_OUTPUT}" ! -name "kustomization.yaml" ! -name "prometheus-alerts.yaml" ! -name "prometheus-rules.yaml" -type f -delete
	@$(MIXTOOL) generate all --output-alerts "${$@_MIXIN_OUTPUT}/alerts.yaml" --output-rules "${$@_MIXIN_OUTPUT}/rules.yaml" --directory "${$@_MIXIN_OUTPUT}/dashboards_out" "${$@_MIXIN_OUTPUT}.libsonnet"
	@../../tools/check-rules.sh "${$@_MIXIN_OUTPUT}/rules.yaml" 20
	@mv ${$@_MIXIN_OUTPUT}/alerts.yaml ${$@_MIXIN_OUTPUT}/${CURRENT_DIR}-alerts.yaml
	@mv ${$@_MIXIN_OUTPUT}/rules.yaml ${$@_MIXIN_OUTPUT}/${CURRENT_DIR}-rules.yaml
endef


.PHONY: build
build: $(MIXTOOL) ## Generates the mixin files
	$(foreach mixin,$(MIXIN_OUT_PATH),$(call build_mixin_func, $(mixin)))

.PHONY: check
check: $(MIXTOOL) build fmt ## Build, fmt and check the mixin files
	@../../tools/find-diff-or-untracked.sh . "$(MIXIN_OUT_PATH)" || (echo "Please build and fmt mixin by running 'make build fmt'" && false); \
	# jb install && \
	# $(MIXTOOL) lint mixin.libsonnet

##@ Dashboards & k8s

.PHONY: manifests
manifests: $(KUSTOMIZE) build ## Generates dashboards for k8s
	$(KUSTOMIZE) build deploy > deploy/manifests/k8s-all-in-one.yaml

# NOTE: dashboards_out has been deprecated, please use build instead
dashboards_out:
	@mkdir -p deploy/dashboards_out deploy/manifests
	jsonnet -J vendor -e '(import "mixin.libsonnet").grafanaDashboards' -m deploy/dashboards_out

prom_alerts.yaml:
	jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusAlerts)' > deploy/$@

prom_rules.yaml:
	jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusRules)'  > deploy/$@

##@ General

.PHONY: help
help:  ## Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/
ifeq ($(OS),Windows_NT)
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-40s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
else
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
endif
