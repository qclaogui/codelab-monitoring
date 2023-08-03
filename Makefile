include .bingo/Variables.mk

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

.PHONY: check
check:  ## Check all the mixin files
check: $(JSONNETFMT) $(MIXTOOL)
	@for app in ${APPS_MIXIN}; do \
		cd "monitoring-mixins/$$app" && make check ; \
		cd -; \
	done


##@ General

.PHONY: help
help:  ## Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/
ifeq ($(OS),Windows_NT)
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-40s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
else
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
endif
