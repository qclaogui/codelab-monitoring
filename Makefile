.DEFAULT_GOAL := help

include .bingo/Variables.mk

##@ Dependencies

.PHONY: install-build-deps
install-build-deps: ## Install dependencies tools
	$(info ******************** downloading dependencies ********************)
	@echo ">> building bingo and setup dependencies tools"
	@go install github.com/bwplotka/bingo@v0.9.0

##@ Lint & fmt

.PHONY: copyright
copyright: $(COPYRIGHT) ## Add Copyright header to .go files.
	@$(COPYRIGHT) $(shell go list -f "{{.Dir}}" ./... | xargs -I {} find {} -name "*.go" | grep -iv "vendor/")
	@echo ">> ensured all .go files have copyright headers"


CONFIG_FILES = $(shell find . -type f -name '*.river')
CONFIG_FILES_IN_DOCKER = $(subst ./, /data/, $(CONFIG_FILES))
.PHONY: fmt
fmt: ## Uses Grafana Agent to fmt the river config
	@for c in $(CONFIG_FILES_IN_DOCKER); do \
		echo "$$c"; \
		docker run -e AGENT_MODE=flow --rm --volume "$(shell pwd):/data" -u $(shell id -u) grafana/agent:v0.40.3 fmt -w $$c ; \
	done


##@ Docker compose


.PHONY: up-monolithic-mode-metrics
up-monolithic-mode-metrics: ## Run monolithic-mode Mimir for metrics
	$(info ******************** run monolithic-mode metrics ********************)
	docker compose \
		--project-name monolithic-metrics \
		--project-directory docker-compose/monolithic-mode/metrics \
		--file docker-compose/monolithic-mode/metrics/compose.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the metrics.")
down-monolithic-mode-metrics:
	docker compose --project-name monolithic-metrics down

.PHONY: up-monolithic-mode-logs
up-monolithic-mode-logs: ## Run monolithic-mode Loki for logs
	$(info ******************** run monolithic-mode logs ********************)
	docker compose \
		--project-name monolithic-logs \
		--project-directory docker-compose/monolithic-mode/logs \
		--file docker-compose/monolithic-mode/logs/compose.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the logs.")
down-monolithic-mode-logs:
	docker compose --project-name monolithic-logs down

.PHONY: up-monolithic-mode-traces
up-monolithic-mode-traces: ## Run monolithic-mode Tempo for traces
	$(info ******************** run monolithic-mode traces ********************)
	docker compose \
		--project-name monolithic-traces \
		--project-directory docker-compose/monolithic-mode/traces \
		--file docker-compose/monolithic-mode/traces/compose.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the traces.")
down-monolithic-mode-traces:
	docker compose --project-name monolithic-traces down

.PHONY: up-monolithic-mode-profiles
up-monolithic-mode-profiles: ## Run monolithic-mode Pyroscope for profiles
	$(info ******************** run monolithic-mode profiles ********************)
	docker compose \
		--project-name monolithic-profiles \
		--project-directory docker-compose/monolithic-mode/profiles \
		--file docker-compose/monolithic-mode/profiles/compose.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the profiles.")
down-monolithic-mode-profiles:
	docker compose --project-name monolithic-profiles down

.PHONY: up-monolithic-mode-all-in-one
up-monolithic-mode-all-in-one: ## Run monolithic-mode all-in-one
	$(info ******************** run monolithic-mode all-in-one ********************)
	docker compose \
		--project-name all-in-one \
		--project-directory docker-compose/monolithic-mode/all-in-one \
		--file docker-compose/monolithic-mode/all-in-one/compose.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the metrics.")
down-monolithic-mode-all-in-one:
	docker compose --project-name all-in-one down


.PHONY: up-read-write-mode-metrics
up-read-write-mode-metrics: ## Run read-write-mode Mimir for metrics
	$(info ******************** run read-write-mode metrics ********************)
	docker compose \
		--project-name read-write-metrics \
		--project-directory docker-compose/read-write-mode/metrics \
		--file docker-compose/read-write-mode/metrics/compose.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the metrics.")
down-read-write-mode-metrics:
	docker compose --project-name read-write-metrics down

.PHONY: up-read-write-mode-logs
up-read-write-mode-logs: ## Run read-write-mode Loki for logs
	$(info ******************** run read-write-mode logs ********************)
	docker compose \
		--project-name read-write-logs \
		--project-directory docker-compose/read-write-mode/logs \
		--file docker-compose/read-write-mode/logs/compose.yaml \
		--file docker-compose/read-write-mode/logs/compose.override.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the logs.")
down-read-write-mode-logs:
	docker compose --project-name read-write-logs down


.PHONY: up-microservices-mode-metrics
up-microservices-mode-metrics: ## Run microservices-mode Mimir for metrics
	$(info ******************** run microservices-mode metrics ********************)
	docker compose \
		--project-name microservices-metrics \
		--project-directory docker-compose/microservices-mode/metrics \
		--file docker-compose/microservices-mode/metrics/compose.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the metrics.")
down-microservices-mode-metrics:
	docker compose --project-name microservices-metrics down

.PHONY: up-microservices-mode-logs
up-microservices-mode-logs: ## Run microservices-mode Loki for logs
	$(info ******************** run microservices-mode logs ********************)
	docker compose \
		--project-name microservices-logs \
		--project-directory docker-compose/microservices-mode/logs \
		--file docker-compose/microservices-mode/logs/compose.yaml \
		--file docker-compose/microservices-mode/logs/compose.override.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the logs.")
down-microservices-mode-logs:
	docker compose --project-name microservices-logs down

.PHONY: up-microservices-mode-traces
up-microservices-mode-traces: ## Run microservices-mode Tempo for traces
	$(info ******************** run microservices-mode traces ********************)
	docker compose \
		--project-name microservices-traces \
		--project-directory docker-compose/microservices-mode/traces \
		--file docker-compose/microservices-mode/traces/compose.yaml \
		--file docker-compose/microservices-mode/traces/compose.override.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the traces.")
down-microservices-mode-traces:
	docker compose --project-name microservices-traces down

.PHONY: up-microservices-mode-profiles
up-microservices-mode-profiles: ## Run microservices-mode Pyroscope for profiles
	$(info ******************** run microservices-mode profiles ********************)
	docker compose \
		--project-name microservices-profiles \
		--project-directory docker-compose/microservices-mode/profiles \
		--file docker-compose/microservices-mode/profiles/compose.yaml \
		--file docker-compose/microservices-mode/profiles/compose.override.yaml \
		--env-file docker-compose/common/config/.env \
		up -d --remove-orphans
	@$(call echo_info, "Go to http://localhost:3000/explore for the profiles.")
down-microservices-mode-profiles:
	docker compose --project-name microservices-profiles down


##@ Kubernetes


.PHONY: cluster
cluster: ## Create k3s cluster
	k3d cluster create k3s-codelab --config kubernetes/k3d-k3s-config.yaml

clean: ## Clean cluster
	k3d cluster delete k3s-codelab
	@rm -rf bin dist .lgtmp .lgtmp.tar
	@rm -rf kubernetes/common/*/charts/

.PHONY: manifests
manifests: ## Generates k8s manifests
manifests: $(KUSTOMIZE) manifests-common manifests-monolithic-mode manifests-read-write-mode manifests-microservices-mode

manifests-common: $(KUSTOMIZE)
	$(info ******************** generates manifests-common manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/gateway > kubernetes/common/gateway/manifests/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana > kubernetes/common/grafana/manifests/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana-agent > kubernetes/common/grafana-agent/manifests/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/kube-prometheus-stack > kubernetes/common/kube-prometheus-stack/manifests/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/memcached > kubernetes/common/memcached/manifests/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/minio-operator > kubernetes/common/minio-operator/manifests/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/minio-tenant > kubernetes/common/minio-tenant/manifests/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/mysql > kubernetes/common/mysql/manifests/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/prometheus-operator-crds > kubernetes/common/prometheus-operator-crds/manifests/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/rancher-pushprox > kubernetes/common/rancher-pushprox/manifests/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/redis > kubernetes/common/redis/manifests/k8s-all-in-one.yaml

manifests-monolithic-mode: $(KUSTOMIZE)
	$(info ******************** generates monolithic-mode manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/logs > kubernetes/monolithic-mode/logs/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/metrics > kubernetes/monolithic-mode/metrics/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/profiles > kubernetes/monolithic-mode/profiles/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/traces > kubernetes/monolithic-mode/traces/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/all-in-one > kubernetes/monolithic-mode/all-in-one/k8s-all-in-one.yaml

manifests-read-write-mode: $(KUSTOMIZE)
	$(info ******************** generates read-write-mode manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/read-write-mode/logs > kubernetes/read-write-mode/logs/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/read-write-mode/metrics > kubernetes/read-write-mode/metrics/k8s-all-in-one.yaml

manifests-microservices-mode: $(KUSTOMIZE)
	$(info ******************** generates microservices-mode manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/logs > kubernetes/microservices-mode/logs/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/metrics > kubernetes/microservices-mode/metrics/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/profiles > kubernetes/microservices-mode/profiles/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/traces > kubernetes/microservices-mode/traces/k8s-all-in-one.yaml

deploy-prometheus-operator-crds:
	$(info ******************** deploy prometheus-operator-crds manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/prometheus-operator-crds | kubectl replace -f - || $(KUSTOMIZE) build --enable-helm kubernetes/common/prometheus-operator-crds | kubectl create -f -

# kube-prometheus-stack
.PHONY: deploy-kube-prometheus-stack
deploy-kube-prometheus-stack: ## Deploy kube-prometheus-stack manifests
	$(info ******************** deploy kube-prometheus-stack manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/kube-prometheus-stack | kubectl apply -f -
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/rancher-pushprox | kubectl apply -f -
delete-kube-prometheus-stack:
	$(info ******************** delete kube-prometheus-stack manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/kube-prometheus-stack | kubectl delete -f -
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/rancher-pushprox | kubectl delete -f -

.PHONY: deploy-minio
deploy-minio:
	$(info ******************** deploy minio manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/minio-operator | kubectl apply -f -
	kubectl rollout status -n minio-system deployment/minio-operator --watch --timeout=600s
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/minio-tenant | kubectl apply -f -
	@echo "Waiting for Minio to be ready..."
	@sleep 20
	kubectl rollout status -n minio-system statefulset/codelab-pool-10gb --watch --timeout=600s || true
delete-minio:
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/minio-tenant | kubectl delete --ignore-not-found -f -
	
.PHONY: deploy-gateway
deploy-gateway:
	$(info ******************** deploy gateway manifests ********************)
	@$(KUSTOMIZE) build kubernetes/common/gateway | kubectl apply -f -
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s

.PHONY: deploy-grafana
deploy-grafana: deploy-prometheus-operator-crds deploy-minio deploy-gateway
	$(info ******************** deploy grafana manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana | kubectl apply -f -
delete-grafana:
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana | kubectl delete --ignore-not-found -f -

define echo_info
	$(eval $@_MSG = $(1))
	@echo ""
	@echo "Demo is running."
	@echo "${$@_MSG}"
endef

define config_changes_trigger_pod_restart
	$(eval $@_MSG = $(1))
	@kubectl rollout restart deployment -n gateway nginx
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s
	@echo "Provisioning Grafana dashboards Prometheus rules and alerts..."
	@$(KUSTOMIZE) build monitoring-mixins | kubectl apply -f -
	kubectl rollout status -n monitoring-system daemonset/grafana-agent --watch --timeout=600s
	@$(call echo_info, ${$@_MSG})
endef


.PHONY: deploy-monolithic-mode-metrics
deploy-monolithic-mode-metrics: deploy-memcached ## Deploy monolithic-mode Mimir for metrics
	$(info ******************** deploy monolithic-mode metrics manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/metrics | kubectl apply -f -
	kubectl rollout status -n monitoring-system deployment/mimir --watch --timeout=600s
	@$(call config_changes_trigger_pod_restart, "Go to http://localhost:8080/explore for the metrics.")
delete-monolithic-mode-metrics: delete-memcached
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/metrics | kubectl delete -f -


.PHONY: deploy-monolithic-mode-logs
deploy-monolithic-mode-logs: deploy-memcached ## Deploy monolithic-mode Loki for logs
	$(info ******************** deploy monolithic-mode logs manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/logs | kubectl apply -f -
	kubectl rollout status -n logging-system statefulset/loki --watch --timeout=600s
	@$(call config_changes_trigger_pod_restart, "Go to http://localhost:8080/explore for the logs.")
delete-monolithic-mode-logs: delete-memcached
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/logs | kubectl delete -f -


.PHONY: deploy-monolithic-mode-profiles
deploy-monolithic-mode-profiles: deploy-memcached ## Deploy monolithic-mode Pyroscope for profiles
	$(info ******************** deploy monolithic-mode profiles manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/profiles | kubectl apply -f -
	kubectl rollout status -n profiles-system statefulset/pyroscope --watch --timeout=600s
	@$(call config_changes_trigger_pod_restart,"Go to http://localhost:8080/explore for the profiles.")
delete-monolithic-mode-profiles: delete-memcached
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/profiles | kubectl delete -f -


.PHONY: deploy-monolithic-mode-traces
deploy-monolithic-mode-traces: deploy-memcached ## Deploy monolithic-mode Tempo for traces
	$(info ******************** deploy monolithic-mode traces manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/traces | kubectl apply -f -
	kubectl rollout status -n tracing-system statefulset/tempo --watch --timeout=600s
	@$(call config_changes_trigger_pod_restart, "Go to http://localhost:8080/explore for the traces.")
delete-monolithic-mode-traces: delete-memcached
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/traces | kubectl delete -f -


.PHONY: deploy-monolithic-mode-all-in-one
deploy-monolithic-mode-all-in-one: deploy-memcached ## Deploy monolithic-mode all-in-one
	$(info ******************** deploy monolithic-mode all-in-one manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/all-in-one | kubectl apply -f -
	kubectl rollout status -n monitoring-system deployment/mimir --watch --timeout=600s
	@$(call config_changes_trigger_pod_restart, "Go to http://localhost:8080/explore for the all-in-one.")
delete-monolithic-mode-all-in-one: delete-memcached
	@$(KUSTOMIZE) build --enable-helm kubernetes/monolithic-mode/all-in-one | kubectl delete -f -



.PHONY: deploy-read-write-mode-metrics
deploy-read-write-mode-metrics: deploy-memcached ## Deploy read-write-mode Mimir for metrics
	$(info ******************** deploy read-write-mode metrics manifests ********************)
	@$(KUSTOMIZE) build kubernetes/read-write-mode/metrics | kubectl apply -f -
	kubectl rollout status -n monitoring-system deployment/mimir-write --watch --timeout=600s
	@$(call config_changes_trigger_pod_restart, "Go to http://localhost:8080/explore for the metrics.")
delete-read-write-mode-metrics: delete-memcached
	@$(KUSTOMIZE) build kubernetes/read-write-mode/metrics | kubectl delete -f -


.PHONY: deploy-read-write-mode-logs
deploy-read-write-mode-logs: deploy-memcached ## Deploy read-write-mode Loki for logs
	$(info ******************** deploy read-write-mode logs manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/read-write-mode/logs | kubectl apply -f -
	kubectl rollout status -n logging-system statefulset/loki-write --watch --timeout=600s
	@$(call config_changes_trigger_pod_restart, "Go to http://localhost:8080/explore for the logs.")
delete-read-write-mode-logs: delete-memcached
	@$(KUSTOMIZE) build --enable-helm kubernetes/read-write-mode/logs | kubectl delete -f -



.PHONY: deploy-microservices-mode-logs
deploy-microservices-mode-logs: deploy-memcached ## Deploy microservices-mode Loki for logs
	$(info ******************** deploy microservices-mode logs manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/logs | kubectl apply -f -
	kubectl rollout status -n logging-system statefulset/loki-distributed-ingester --watch --timeout=600s
	@$(call config_changes_trigger_pod_restart, "Go to http://localhost:8080/explore for the logs.")
delete-microservices-mode-logs: delete-memcached
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/logs | kubectl delete -f -


.PHONY: deploy-microservices-mode-metrics
deploy-microservices-mode-metrics: deploy-memcached ## Deploy microservices-mode Mimir for metrics
	$(info ******************** deploy microservices-mode metrics manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/metrics | kubectl apply -f -
	kubectl rollout status -n monitoring-system statefulset/mimir-distributed-ingester --watch --timeout=600s
	@$(call config_changes_trigger_pod_restart, "Go to http://localhost:8080/explore for the metrics.")
delete-microservices-mode-metrics: delete-memcached
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/metrics | kubectl delete -f -


.PHONY: deploy-microservices-mode-profiles
deploy-microservices-mode-profiles: deploy-memcached ## Deploy microservices-mode Pyroscope for profiles
	$(info ******************** deploy microservices-mode profiles manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/profiles | kubectl apply -f -
	@$(call config_changes_trigger_pod_restart, "Go to http://localhost:8080/explore for the profiles.")
delete-microservices-mode-profiles: delete-memcached
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/profiles | kubectl delete -f -


.PHONY: deploy-microservices-mode-traces
deploy-microservices-mode-traces: deploy-memcached ## Deploy microservices-mode Tempo for traces
	$(info ******************** deploy microservices-mode traces manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/traces | kubectl apply -f -
	kubectl rollout status -n tracing-system statefulset/tempo-distributed-ingester --watch --timeout=600s
	@$(call config_changes_trigger_pod_restart, "Go to http://localhost:8080/explore for the traces.")
delete-microservices-mode-traces: delete-memcached
	@$(KUSTOMIZE) build --enable-helm kubernetes/microservices-mode/traces | kubectl delete -f -


##@ Grafana Agent Integrations

deploy-memcached: deploy-grafana
	$(info ******************** deploy integration memcached manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/memcached | kubectl apply -f -
delete-memcached: delete-minio
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/memcached | kubectl delete --ignore-not-found -f -

.PHONY: deploy-mysql
deploy-mysql: ## Deploy integration mysql manifests
	$(info ******************** deploy integration mysql manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/mysql | kubectl apply -f -
delete-mysql:
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/mysql | kubectl delete --ignore-not-found -f -

.PHONY: deploy-redis
deploy-redis: ## Deploy integration redis manifests
	$(info ******************** deploy integration redis manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/redis | kubectl apply -f -
delete-redis:
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/redis | kubectl delete --ignore-not-found -f -


##@ Build

GOOS             ?= $(shell go env GOOS)
GOARCH           ?= $(shell go env GOARCH)
GOARM            ?= $(shell go env GOARM)
CGO_ENABLED      ?= 0
RELEASE_BUILD    ?= 0


GOPROXY          ?= https://proxy.golang.org
export GOPROXY

GO_ENV := GOOS=$(GOOS) GOARCH=$(GOARCH) GOARM=$(GOARM) CGO_ENABLED=$(CGO_ENABLED)

VERSION 	?= $(shell ./tools/image-tag)
COMMIT_NO 	?= $(shell git rev-parse --short HEAD 2> /dev/null || true)
GIT_COMMIT 	?= $(if $(shell git status --porcelain --untracked-files=no),${COMMIT_NO}-dirty,${COMMIT_NO})
VPREFIX 	:= github.com/qclaogui/codelab-monitoring/pkg/version

GO_LDFLAGS  := -X $(VPREFIX).Version=$(VERSION)                         \
               -X $(VPREFIX).GitCommit=$(GIT_COMMIT)                    \
               -X $(VPREFIX).BuildDate=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

DEFAULT_FLAGS	:= $(GO_FLAGS)

ifeq ($(RELEASE_BUILD),1)
GO_FLAGS	:= $(DEFAULT_FLAGS) -ldflags "-s -w $(GO_LDFLAGS)"
else
GO_FLAGS	:= $(DEFAULT_FLAGS) -ldflags "$(GO_LDFLAGS)"
endif


.PHONY: generate
generate: ## generate embed deps
	@$(GO_ENV) go generate


.PHONY: build
build: generate ## Build binary for current OS and place it at ./bin/lgtmp_$(GOOS)_$(GOARCH)
	@$(GO_ENV) go build $(GO_FLAGS) -o bin/lgtmp_$(GOOS)_$(GOARCH) ./cmd/lgtmp
	@$(GO_ENV) go build $(GO_FLAGS) -o bin/lgtmp ./cmd/lgtmp

.PHONY: build-all
build-all: $(GORELEASER) generate ## Build binaries for Linux and Mac and place them in dist/
	@cat ./.goreleaser.yml ./.goreleaser.brew.yml > .goreleaser.combined.yml
	RELEASE_BUILD=$(RELEASE_BUILD) PRE_RELEASE_ID="" $(GORELEASER) --config=.goreleaser.combined.yml --snapshot --skip=publish --clean
	@rm .goreleaser.combined.yml


##@ Release

prepare-release-candidate: ## Create release candidate
	tools/scripts/tag-release-candidate.sh

prepare-release: ## Create release
	tools/scripts/tag-release.sh

.PHONY: print-version
print-version: ## Prints the upcoming release number
	@go run pkg/version/generate/release_generate.go print-version


##@ General

console-token: ## Prints the minio-operator console jwt token
	@kubectl get secret/console-sa-secret -n minio-system -o json | jq -r ".data.token" | base64 -d

.PHONY: help
help:  ## Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/
ifeq ($(OS),Windows_NT)
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-40s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
else
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
endif
