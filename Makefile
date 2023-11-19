.DEFAULT_GOAL := help

include .bingo/Variables.mk

GOPROXY  ?= https://proxy.golang.org
export GOPROXY

# support app's mixin
APPS_MIXIN := "agent-flow-mixin" "go-runtime-mixin"

# path to the grafana provisioning dashboards
GRAFANA_DASHBOARDS_PATH := docker-compose/common/config/grafana/dashboards


##@ Dependencies

.PHONY: install-build-deps
install-build-deps: ## Install dependencies tools
	$(info ******************** downloading dependencies ********************)
	@echo ">> building bingo and setup dependencies tools"
	@go install github.com/bwplotka/bingo@latest


##@ Dashboards

.PHONY: dashboards_out
dashboards_out: ## Copy app's dashboards to grafana dashboards provision path
	@for app in ${APPS_MIXIN}; do \
		mkdir -p "$(GRAFANA_DASHBOARDS_PATH)/$$app"; \
		cd "monitoring-mixins/$$app" && cp -f deploy/dashboards_out/* "../../$(GRAFANA_DASHBOARDS_PATH)/$$app/"; \
		cd -; \
	done


##@ Lint & fmt

.PHONY: check
check:  ## Check all the mixin files
check: $(JSONNETFMT) $(MIXTOOL) copyright
	@for app in ${APPS_MIXIN}; do \
		cd "monitoring-mixins/$$app" && make check ; \
		cd -; \
	done

.PHONY: copyright
copyright: $(COPYRIGHT) ## Add Copyright header to .go files.
	@$(COPYRIGHT) $(shell go list -f "{{.Dir}}" ./... | xargs -I {} find {} -name "*.go")
	@echo ">> ensured all .go files have copyright headers"

##@ Kubernetes

.PHONY: cluster
cluster: ## Create k3s cluster
	k3d cluster create k3s-codelab --config kubernetes/k3d-k3s-config.yaml

image-import: ## Import image(s) from docker into k3d cluster(s).
	k3d image import -c k3s-codelab grafana/pyroscope:1.2.0

clean: ## Clean cluster
	k3d cluster delete k3s-codelab

.PHONY: manifests
manifests: ## Generates k8s manifests
manifests: $(KUSTOMIZE) manifests-common manifests-monolithic-mode manifests-read-write-mode manifests-microservices-mode
	@$(KUSTOMIZE) build monitoring-mixins > monitoring-mixins/k8s-all-in-one.yaml

.PHONY: manifests-common
manifests-common: $(KUSTOMIZE)  ## Generates manifests-common manifests
	$(info ******************** generates manifests-common manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana-agent > kubernetes/common/grafana-agent/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana > kubernetes/common/grafana/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/kube-prometheus-stack > kubernetes/common/kube-prometheus-stack/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/prometheus-blackbox-exporter > kubernetes/common/prometheus-blackbox-exporter/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/prometheus-operator-crds > kubernetes/common/prometheus-operator-crds/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/rancher-pushprox > kubernetes/common/rancher-pushprox/k8s-all-in-one.yaml


.PHONY: manifests-monolithic-mode
manifests-monolithic-mode: $(KUSTOMIZE)  ## Generates monolithic-mode manifests
	$(info ******************** generates monolithic-mode manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/logs > kubernetes/monolithic-mode/logs/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/profiles > kubernetes/monolithic-mode/profiles/k8s-all-in-one.yaml

.PHONY: manifests-read-write-mode
manifests-read-write-mode: $(KUSTOMIZE)  ## Generates read-write-mode manifests
	$(info ******************** generates read-write-mode manifests ********************)
	@$(KUSTOMIZE) build kubernetes/read-write-mode/logs > kubernetes/read-write-mode/logs/k8s-all-in-one.yaml

.PHONY: manifests-microservices-mode
manifests-microservices-mode: $(KUSTOMIZE)  ## Generates microservices-mode manifests
	$(info ******************** generates microservices-mode manifests ********************)
	@$(KUSTOMIZE) build kubernetes/microservices-mode/metrics > kubernetes/microservices-mode/metrics/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/microservices-mode/logs > kubernetes/microservices-mode/logs/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/microservices-mode/profiles > kubernetes/microservices-mode/profiles/k8s-all-in-one.yaml


# prometheus-operator-crds
.PHONY: deploy-prometheus-operator-crds
deploy-prometheus-operator-crds: ## Deploy prometheus-operator-crds manifests
	$(info ******************** deploy prometheus-operator-crds manifests ********************)
	@kubectl replace -f kubernetes/common/prometheus-operator-crds/k8s-all-in-one.yaml || kubectl create -f kubernetes/common/prometheus-operator-crds/k8s-all-in-one.yaml

# kube-prometheus-stack
.PHONY: deploy-kube-prometheus-stack
deploy-kube-prometheus-stack: ## Deploy kube-prometheus-stack manifests
	$(info ******************** deploy kube-prometheus-stack manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/kube-prometheus-stack | kubectl apply -f -
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/rancher-pushprox | kubectl apply -f -

delete-kube-prometheus-stack: ## Delete kube-prometheus-stack manifests
	$(info ******************** delete kube-prometheus-stack manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/kube-prometheus-stack | kubectl delete -f -
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/rancher-pushprox | kubectl delete -f -


.PHONY: deploy-grafana
deploy-grafana: deploy-prometheus-operator-crds ## Deploy grafana manifests
	$(info ******************** deploy grafana manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana | kubectl apply -f -
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana-agent | kubectl apply -f -

delete-grafana: ## Delete grafana manifests
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana-agent | kubectl delete --ignore-not-found -f -
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana | kubectl delete --ignore-not-found -f -

# .PHONY: deploy-blackbox-exporter
# deploy-blackbox-exporter: ## Deploy blackbox-exporter manifests
# 	$(info ******************** deploy blackbox-exporter manifests ********************)
# 	@$(KUSTOMIZE) build --enable-helm kubernetes/common/prometheus-blackbox-exporter | kubectl apply -f -


# Kubernetes monolithic-mode
.PHONY: deploy-monolithic-mode-logs
deploy-monolithic-mode-logs: deploy-grafana ## Deploy monolithic-mode logs
	$(info ******************** deploy monolithic-mode logs manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/logs | kubectl apply -f -

delete-monolithic-mode-logs: ## Delete monolithic-mode logs
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/logs | kubectl delete -f -

.PHONY: deploy-monolithic-mode-profiles
deploy-monolithic-mode-profiles: deploy-grafana ## Deploy monolithic-mode profiles
	$(info ******************** deploy monolithic-mode profiles manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/profiles | kubectl apply -f -

delete-monolithic-mode-profiles: ## Delete monolithic-mode profiles
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/profiles | kubectl delete -f -



# Kubernetes read-write-mode
.PHONY: deploy-read-write-mode-logs
deploy-read-write-mode-logs: deploy-grafana ## Deploy read-write-mode logs
	$(info ******************** deploy read-write-mode logs manifests ********************)
	@$(KUSTOMIZE) build kubernetes/read-write-mode/logs | kubectl apply -f -

delete-read-write-mode-logs: ## Delete read-write-mode logs
	@$(KUSTOMIZE) build kubernetes/read-write-mode/logs | kubectl delete -f -



# Kubernetes microservices-mode
.PHONY: deploy-microservices-mode-metrics
deploy-microservices-mode-metrics: deploy-grafana ## Deploy microservices-mode metrics
	$(info ******************** deploy microservices-mode metrics manifests ********************)
	@$(KUSTOMIZE) build kubernetes/microservices-mode/metrics | kubectl apply -f -
	@$(KUSTOMIZE) build monitoring-mixins | kubectl apply -f -

delete-microservices-mode-metrics: ## Delete microservices-mode metrics
	@$(KUSTOMIZE) build kubernetes/microservices-mode/metrics | kubectl delete -f -
	@$(KUSTOMIZE) build monitoring-mixins | kubectl delete -f -


.PHONY: deploy-microservices-mode-profiles
deploy-microservices-mode-profiles: deploy-grafana ## Deploy microservices-mode profiles
	$(info ******************** deploy microservices-mode profiles manifests ********************)
	@$(KUSTOMIZE) build kubernetes/microservices-mode/profiles | kubectl apply -f -

delete-microservices-mode-profiles: ## Delete microservices-mode profiles
	@$(KUSTOMIZE) build kubernetes/microservices-mode/profiles | kubectl delete -f -

##@ General

.PHONY: help
help:  ## Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/
ifeq ($(OS),Windows_NT)
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-40s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
else
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
endif
