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

.PHONY: clean
clean: ## Clean cluster
	k3d cluster delete k3s-codelab

.PHONY: manifests
manifests: ## Generates k8s manifests
manifests: $(KUSTOMIZE) monolithic-mode-manifests microservices-mode-manifests
	@$(KUSTOMIZE) build monitoring-mixins > monitoring-mixins/k8s-all-in-one.yaml

.PHONY: monolithic-mode-manifests
monolithic-mode-manifests: $(KUSTOMIZE)  ## Generates monolithic-mode manifests
	$(info ******************** generates monolithic-mode manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/logs > kubernetes/monolithic-mode/logs/k8s-all-in-one.yaml


.PHONY: microservices-mode-manifests
microservices-mode-manifests: $(KUSTOMIZE)  ## Generates microservices-mode manifests
	$(info ******************** generates microservices-mode manifests ********************)
	@$(KUSTOMIZE) build kubernetes/microservices-mode/metrics > kubernetes/microservices-mode/metrics/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/microservices-mode/logs > kubernetes/microservices-mode/logs/k8s-all-in-one.yaml

.PHONY: logs-monolithic-mode-deploy
logs-monolithic-mode-deploy: manifests ## Deploy monolithic-mode logs
	$(info ******************** deploy manifests ********************)
	@kubectl apply -f kubernetes/grafana/k8s-all-in-one.yaml
	@kubectl apply -f kubernetes/monolithic-mode/logs/k8s-all-in-one.yaml
	@kubectl apply -f kubernetes/monolithic-mode/logs/grafana-datasources-loki.yaml 
	@kubectl apply -f monitoring-mixins/k8s-all-in-one.yaml

.PHONY: logs-monolithic-mode-clean
logs-monolithic-mode-clean:  ## Clean monolithic-mode logs manifests
	$(info ******************** clean manifests ********************)
	@kubectl delete -f kubernetes/grafana/k8s-all-in-one.yaml
	@kubectl delete -f kubernetes/monolithic-mode/logs/k8s-all-in-one.yaml
	@kubectl delete -f kubernetes/monolithic-mode/logs/grafana-datasources-loki.yaml 
	@kubectl delete -f monitoring-mixins/k8s-all-in-one.yaml


.PHONY: metrics-microservices-mode-deploy
metrics-microservices-mode-deploy: manifests ## Deploy microservices-mode metrics
	$(info ******************** deploy manifests ********************)
	kubectl apply -f kubernetes/grafana/k8s-all-in-one.yaml
	kubectl apply -f kubernetes/microservices-mode/metrics/k8s-all-in-one.yaml
	kubectl apply -f kubernetes/microservices-mode/metrics/grafana-datasources-mimir.yaml 
	kubectl apply -f monitoring-mixins/k8s-all-in-one.yaml

.PHONY: metrics-microservices-mode-clean
metrics-microservices-mode-clean:  ## Clean microservices-mode metrics
	$(info ******************** clean manifests ********************)
	kubectl delete -f kubernetes/grafana/k8s-all-in-one.yaml
	kubectl delete -f kubernetes/microservices-mode/metrics/k8s-all-in-one.yaml
	kubectl delete -f kubernetes/microservices-mode/metrics/grafana-datasources-mimir.yaml 
	kubectl delete -f monitoring-mixins/k8s-all-in-one.yaml


##@ General

.PHONY: help
help:  ## Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/
ifeq ($(OS),Windows_NT)
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-40s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
else
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
endif
