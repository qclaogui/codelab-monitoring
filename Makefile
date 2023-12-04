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


CONFIG_FILES = $(shell find . -type f -name '*.river')
CONFIG_FILES_IN_DOCKER = $(subst ./, /data/, $(CONFIG_FILES))
.PHONY: fmt
fmt: ## Uses Grafana Agent to fmt the river config
	@for c in $(CONFIG_FILES_IN_DOCKER); do \
		echo "$$c"; \
		docker run -e AGENT_MODE=flow --rm --volume "$(shell pwd):/data" -u $(shell id -u) grafana/agent:v0.38.1 fmt -w $$c ; \
	done

##@ Docker compose

# Docker monolithic-mode
.PHONY: up-monolithic-mode-metrics
up-monolithic-mode-metrics: ## Run monolithic-mode metrics
	$(info ******************** run monolithic-mode metrics ********************)
	docker compose --project-directory docker-compose/monolithic-mode/metrics --file docker-compose/monolithic-mode/metrics/docker-compose.yaml up -d --remove-orphans
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:3000/explore for the metrics."
down-monolithic-mode-metrics:
	docker compose --project-directory docker-compose/monolithic-mode/metrics --file docker-compose/monolithic-mode/metrics/docker-compose.yaml down

.PHONY: up-monolithic-mode-logs
up-monolithic-mode-logs: ## Run monolithic-mode logs
	$(info ******************** run monolithic-mode logs ********************)
	docker compose --project-directory docker-compose/monolithic-mode/logs --file docker-compose/monolithic-mode/logs/docker-compose.yaml up -d --remove-orphans
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:3000/explore for the logs."

down-monolithic-mode-logs:
	docker compose --project-directory docker-compose/monolithic-mode/logs --file docker-compose/monolithic-mode/logs/docker-compose.yaml down

.PHONY: up-monolithic-mode-traces
up-monolithic-mode-traces: ## Run monolithic-mode traces
	$(info ******************** run monolithic-mode traces ********************)
	docker compose --project-directory docker-compose/monolithic-mode/traces --file docker-compose/monolithic-mode/traces/docker-compose.yaml up -d --remove-orphans
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:3000/explore for the traces."
down-monolithic-mode-traces:
	docker compose --project-directory docker-compose/monolithic-mode/traces --file docker-compose/monolithic-mode/traces/docker-compose.yaml down

.PHONY: up-monolithic-mode-profiles
up-monolithic-mode-profiles: ## Run monolithic-mode profiles
	$(info ******************** run monolithic-mode profiles ********************)
	docker compose --project-directory docker-compose/monolithic-mode/profiles --file docker-compose/monolithic-mode/profiles/docker-compose.yaml up -d --remove-orphans
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:3000/explore for the profiles."
down-monolithic-mode-profiles:
	docker compose --project-directory docker-compose/monolithic-mode/profiles --file docker-compose/monolithic-mode/profiles/docker-compose.yaml down

.PHONY: up-monolithic-mode-all-in-one
up-monolithic-mode-all-in-one: ## Run monolithic-mode all-in-one
	$(info ******************** run monolithic-mode all-in-one ********************)
	docker compose --project-directory docker-compose/monolithic-mode/all-in-one --file docker-compose/monolithic-mode/all-in-one/docker-compose.yaml up -d --remove-orphans
down-monolithic-mode-all-in-one:
	docker compose --project-directory docker-compose/monolithic-mode/all-in-one --file docker-compose/monolithic-mode/all-in-one/docker-compose.yaml down

# Docker read-write-mode
.PHONY: up-read-write-mode-metrics
up-read-write-mode-metrics: ## Run read-write-mode metrics
	$(info ******************** run read-write-mode metrics ********************)
	docker compose --project-directory docker-compose/read-write-mode/metrics --file docker-compose/read-write-mode/metrics/docker-compose.yaml up -d --remove-orphans
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:3000/explore for the metrics."
down-read-write-mode-metrics:
	docker compose --project-directory docker-compose/read-write-mode/metrics --file docker-compose/read-write-mode/metrics/docker-compose.yaml down

.PHONY: up-read-write-mode-logs
up-read-write-mode-logs: ## Run read-write-mode logs
	$(info ******************** run read-write-mode logs ********************)
	docker compose --project-directory docker-compose/read-write-mode/logs --file docker-compose/read-write-mode/logs/docker-compose.yaml up -d --remove-orphans
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:3000/explore for the logs."
down-read-write-mode-logs:
	docker compose --project-directory docker-compose/read-write-mode/logs --file docker-compose/read-write-mode/logs/docker-compose.yaml down


# Docker microservices-mode
.PHONY: up-microservices-mode-metrics
up-microservices-mode-metrics: ## Run microservices-mode metrics
	$(info ******************** run microservices-mode metrics ********************)
	docker compose --project-directory docker-compose/microservices-mode/metrics --file docker-compose/microservices-mode/metrics/docker-compose.yaml up -d --remove-orphans
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:3000/explore for the metrics."
down-microservices-mode-metrics:
	docker compose --project-directory docker-compose/microservices-mode/metrics --file docker-compose/microservices-mode/metrics/docker-compose.yaml down

.PHONY: up-microservices-mode-logs
up-microservices-mode-logs: ## Run microservices-mode logs
	$(info ******************** run microservices-mode logs ********************)
	docker compose --project-directory docker-compose/microservices-mode/logs --file docker-compose/microservices-mode/logs/docker-compose.yaml up -d --remove-orphans
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:3000/explore for the logs."
down-microservices-mode-logs:
	docker compose --project-directory docker-compose/microservices-mode/logs --file docker-compose/microservices-mode/logs/docker-compose.yaml down

.PHONY: up-microservices-mode-traces
up-microservices-mode-traces: ## Run microservices-mode traces
	$(info ******************** run microservices-mode traces ********************)
	docker compose --project-directory docker-compose/microservices-mode/traces --file docker-compose/microservices-mode/traces/docker-compose.yaml up -d --remove-orphans
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:3000/explore for the traces."
down-microservices-mode-traces:
	docker compose --project-directory docker-compose/microservices-mode/traces --file docker-compose/microservices-mode/traces/docker-compose.yaml down

.PHONY: up-microservices-mode-profiles
up-microservices-mode-profiles: ## Run microservices-mode profiles
	$(info ******************** run microservices-mode profiles ********************)
	docker compose --project-directory docker-compose/microservices-mode/profiles --file docker-compose/microservices-mode/profiles/docker-compose.yaml up -d --remove-orphans
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:3000/explore for the profiles."
down-microservices-mode-profiles:
	docker compose --project-directory docker-compose/microservices-mode/profiles --file docker-compose/microservices-mode/profiles/docker-compose.yaml down


##@ Kubernetes

.PHONY: cluster
cluster: ## Create k3s cluster
	k3d cluster create k3s-codelab --config kubernetes/k3d-k3s-config.yaml

# image-import:
# # Import image(s) from docker into k3d cluster(s).
# 	k3d image import -c k3s-codelab grafana/pyroscope:1.2.0

clean: ## Clean cluster
	k3d cluster delete k3s-codelab

.PHONY: manifests
manifests: ## Generates k8s manifests
manifests: $(KUSTOMIZE) manifests-common manifests-monolithic-mode manifests-read-write-mode manifests-microservices-mode
	@$(KUSTOMIZE) build monitoring-mixins > monitoring-mixins/k8s-all-in-one.yaml

manifests-common: $(KUSTOMIZE)
	$(info ******************** generates manifests-common manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/gateway > kubernetes/common/gateway/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana > kubernetes/common/grafana/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana-agent > kubernetes/common/grafana-agent/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/kube-prometheus-stack > kubernetes/common/kube-prometheus-stack/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/memcached > kubernetes/common/memcached/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/minio-operator > kubernetes/common/minio-operator/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/minio-tenant > kubernetes/common/minio-tenant/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/mysql > kubernetes/common/mysql/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/prometheus-operator-crds > kubernetes/common/prometheus-operator-crds/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/rancher-pushprox > kubernetes/common/rancher-pushprox/k8s-all-in-one.yaml


.PHONY: manifests-monolithic-mode
manifests-monolithic-mode: $(KUSTOMIZE)  ## Generates monolithic-mode manifests
	$(info ******************** generates monolithic-mode manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/logs > kubernetes/monolithic-mode/logs/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/metrics > kubernetes/monolithic-mode/metrics/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/profiles > kubernetes/monolithic-mode/profiles/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/traces > kubernetes/monolithic-mode/traces/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/monolithic-mode > kubernetes/monolithic-mode/k8s-all-in-one.yaml

.PHONY: manifests-read-write-mode
manifests-read-write-mode: $(KUSTOMIZE)  ## Generates read-write-mode manifests
	$(info ******************** generates read-write-mode manifests ********************)
	@$(KUSTOMIZE) build kubernetes/read-write-mode/logs > kubernetes/read-write-mode/logs/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/read-write-mode/metrics > kubernetes/read-write-mode/metrics/k8s-all-in-one.yaml

.PHONY: manifests-microservices-mode
manifests-microservices-mode: $(KUSTOMIZE)  ## Generates microservices-mode manifests
	$(info ******************** generates microservices-mode manifests ********************)
	@$(KUSTOMIZE) build kubernetes/microservices-mode/logs > kubernetes/microservices-mode/logs/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/microservices-mode/metrics > kubernetes/microservices-mode/metrics/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/microservices-mode/profiles > kubernetes/microservices-mode/profiles/k8s-all-in-one.yaml
	@$(KUSTOMIZE) build kubernetes/microservices-mode/traces > kubernetes/microservices-mode/traces/k8s-all-in-one.yaml


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
delete-kube-prometheus-stack:
	$(info ******************** delete kube-prometheus-stack manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/kube-prometheus-stack | kubectl delete -f -
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/rancher-pushprox | kubectl delete -f -

# memcached
.PHONY: deploy-memcached
deploy-memcached: ## Deploy memcached manifests
	$(info ******************** deploy memcached manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/memcached | kubectl apply -f -
delete-memcached:
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/memcached | kubectl delete --ignore-not-found -f -

# minio
.PHONY: deploy-minio
deploy-minio: ## Deploy minio manifests
	$(info ******************** deploy minio manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/minio-operator | kubectl apply -f -
	kubectl rollout status -n minio-system deployment/minio-operator --watch --timeout=600s
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/minio-tenant | kubectl apply -f -

# mysql
.PHONY: deploy-mysql
deploy-mysql: ## Deploy mysql manifests
	$(info ******************** deploy mysql manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/mysql | kubectl apply -f -
delete-mysql:
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/mysql | kubectl delete --ignore-not-found -f -

# redis
.PHONY: deploy-redis
deploy-redis: ## Deploy redis manifests
	$(info ******************** deploy redis manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/redis | kubectl apply -f -
delete-redis:
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/redis | kubectl delete --ignore-not-found -f -

# gateway
.PHONY: deploy-gateway
deploy-gateway: ## Deploy gateway manifests
	$(info ******************** deploy gateway manifests ********************)
	@$(KUSTOMIZE) build kubernetes/common/gateway | kubectl apply -f -
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s

# minio-operator console jwt token 
minio-token:
	@kubectl get secret/console-sa-secret -n minio-system -o json | jq -r ".data.token" | base64 -d

.PHONY: deploy-grafana
deploy-grafana: deploy-prometheus-operator-crds deploy-minio deploy-gateway ## Deploy grafana manifests
	$(info ******************** deploy grafana manifests ********************)
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana | kubectl apply -f -
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana-agent | kubectl apply -f -
	kubectl rollout status -n monitoring-system deployment/grafana --watch --timeout=600s
	kubectl rollout status -n minio-system statefulset/codelab-pool-10gb --watch --timeout=600s
delete-grafana:
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana-agent | kubectl delete --ignore-not-found -f -
	@$(KUSTOMIZE) build --enable-helm kubernetes/common/grafana | kubectl delete --ignore-not-found -f -



# Kubernetes monolithic-mode
.PHONY: deploy-monolithic-mode-metrics
deploy-monolithic-mode-metrics: deploy-grafana ## Deploy monolithic-mode metrics
	$(info ******************** deploy monolithic-mode metrics manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/metrics | kubectl apply -f -
	@$(KUSTOMIZE) build monitoring-mixins | kubectl apply -f -
	kubectl rollout status -n monitoring-system deployment/mimir --watch --timeout=600s
	@kubectl rollout restart daemonset -n monitoring-system grafana-agent
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the metrics."
delete-monolithic-mode-metrics:
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/metrics | kubectl delete -f -


.PHONY: deploy-monolithic-mode-logs
deploy-monolithic-mode-logs: deploy-grafana ## Deploy monolithic-mode logs
	$(info ******************** deploy monolithic-mode logs manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/logs | kubectl apply -f -
	kubectl rollout status -n logging-system statefulset/loki --watch --timeout=600s
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the logs."
delete-monolithic-mode-logs:
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/logs | kubectl delete -f -


.PHONY: deploy-monolithic-mode-profiles
deploy-monolithic-mode-profiles: deploy-grafana ## Deploy monolithic-mode profiles
	$(info ******************** deploy monolithic-mode profiles manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/profiles | kubectl apply -f -
	kubectl rollout status -n profiles-system statefulset/pyroscope --watch --timeout=600s
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the profiles."
delete-monolithic-mode-profiles:
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/profiles | kubectl delete -f -


.PHONY: deploy-monolithic-mode-traces
deploy-monolithic-mode-traces: deploy-grafana ## Deploy monolithic-mode traces
	$(info ******************** deploy monolithic-mode traces manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/traces | kubectl apply -f -
	kubectl rollout status -n tracing-system statefulset/tempo --watch --timeout=600s
	@kubectl rollout restart deployment -n gateway nginx
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s
	@kubectl rollout restart deployment -n monitoring-system grafana
	kubectl rollout status -n monitoring-system deployment/grafana --watch --timeout=600s
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the traces."
delete-monolithic-mode-traces:
	@$(KUSTOMIZE) build kubernetes/monolithic-mode/traces | kubectl delete -f -


.PHONY: deploy-monolithic-mode-all-in-one
deploy-monolithic-mode-all-in-one: deploy-grafana ## Deploy monolithic-mode all-in-one
	$(info ******************** deploy monolithic-mode all-in-one manifests ********************)
	@$(KUSTOMIZE) build kubernetes/monolithic-mode | kubectl apply -f -
	@$(KUSTOMIZE) build monitoring-mixins | kubectl apply -f -
	kubectl rollout status -n monitoring-system deployment/mimir --watch --timeout=600s
	@kubectl rollout restart deployment -n gateway nginx
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s
	@kubectl rollout restart daemonset -n monitoring-system grafana-agent	
	@kubectl rollout restart deployment -n monitoring-system grafana
	kubectl rollout status -n monitoring-system deployment/grafana --watch --timeout=600s
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the all-in-one."
delete-monolithic-mode-all-in-one:
	@$(KUSTOMIZE) build kubernetes/monolithic-mode | kubectl delete -f -



# Kubernetes read-write-mode
.PHONY: deploy-read-write-mode-metrics
deploy-read-write-mode-metrics: deploy-grafana ## Deploy read-write-mode metrics
	$(info ******************** deploy read-write-mode metrics manifests ********************)
	@$(KUSTOMIZE) build kubernetes/read-write-mode/metrics | kubectl apply -f -
	@$(KUSTOMIZE) build monitoring-mixins | kubectl apply -f -
	kubectl rollout status -n monitoring-system deployment/mimir-write --watch --timeout=600s
	@kubectl rollout restart deployment -n gateway nginx
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s
	@kubectl rollout restart daemonset -n monitoring-system grafana-agent
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the metrics."
delete-read-write-mode-metrics:
	@$(KUSTOMIZE) build kubernetes/read-write-mode/metrics | kubectl delete -f -


.PHONY: deploy-read-write-mode-logs
deploy-read-write-mode-logs: deploy-grafana ## Deploy read-write-mode logs
	$(info ******************** deploy read-write-mode logs manifests ********************)
	@$(KUSTOMIZE) build kubernetes/read-write-mode/logs | kubectl apply -f -
	kubectl rollout status -n logging-system statefulset/loki-write --watch --timeout=600s
	@kubectl rollout restart deployment -n gateway nginx
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the logs."
delete-read-write-mode-logs:
	@$(KUSTOMIZE) build kubernetes/read-write-mode/logs | kubectl delete -f -




# Kubernetes microservices-mode
.PHONY: deploy-microservices-mode-logs
deploy-microservices-mode-logs: deploy-grafana ## Deploy microservices-mode logs
	$(info ******************** deploy microservices-mode logs manifests ********************)
	@$(KUSTOMIZE) build kubernetes/microservices-mode/logs | kubectl apply -f -
	kubectl rollout status -n logging-system statefulset/loki-distributed-ingester --watch --timeout=600s
	@kubectl rollout restart deployment -n gateway nginx
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the logs."
delete-microservices-mode-logs:
	@$(KUSTOMIZE) build kubernetes/microservices-mode/logs | kubectl delete -f -


.PHONY: deploy-microservices-mode-metrics
deploy-microservices-mode-metrics: deploy-grafana ## Deploy microservices-mode metrics
	$(info ******************** deploy microservices-mode metrics manifests ********************)
	@$(KUSTOMIZE) build kubernetes/microservices-mode/metrics | kubectl apply -f -
	@$(KUSTOMIZE) build monitoring-mixins | kubectl apply -f -
	kubectl rollout status -n monitoring-system statefulset/mimir-distributed-ingester --watch --timeout=600s
	@kubectl rollout restart deployment -n gateway nginx
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s
	@kubectl rollout restart daemonset -n monitoring-system grafana-agent
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the metrics."
delete-microservices-mode-metrics:
	@$(KUSTOMIZE) build kubernetes/microservices-mode/metrics | kubectl delete -f -
	@$(KUSTOMIZE) build monitoring-mixins | kubectl delete -f -


.PHONY: deploy-microservices-mode-profiles
deploy-microservices-mode-profiles: deploy-grafana ## Deploy microservices-mode profiles
	$(info ******************** deploy microservices-mode profiles manifests ********************)
	@$(KUSTOMIZE) build kubernetes/microservices-mode/profiles | kubectl apply -f -
	@kubectl rollout restart deployment -n gateway nginx
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the profiles."
delete-microservices-mode-profiles:
	@$(KUSTOMIZE) build kubernetes/microservices-mode/profiles | kubectl delete -f -


.PHONY: deploy-microservices-mode-traces
deploy-microservices-mode-traces: deploy-grafana ## Deploy microservices-mode traces
	$(info ******************** deploy microservices-mode traces manifests ********************)
	@$(KUSTOMIZE) build kubernetes/microservices-mode/traces | kubectl apply -f -
	kubectl rollout status -n tracing-system statefulset/tempo-distributed-ingester --watch --timeout=600s
	@kubectl rollout restart deployment -n gateway nginx
	kubectl rollout status -n gateway deployment/nginx --watch --timeout=600s
	@kubectl rollout restart deployment -n monitoring-system grafana
	kubectl rollout status -n monitoring-system deployment/grafana --watch --timeout=600s
	@echo ""
	@echo "Demo is running."
	@echo "Go to http://localhost:8080/explore for the traces."
delete-microservices-mode-traces:
	@$(KUSTOMIZE) build kubernetes/microservices-mode/traces | kubectl delete -f -


##@ General

.PHONY: help
help:  ## Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/
ifeq ($(OS),Windows_NT)
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-40s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
else
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
endif
