SHELL = /usr/bin/env bash

APPS_MIXIN := "agent-flow-mixin" "go-runtime-mixin" "mimir-mixin" "loki-mixin"

# path to the grafana provisioning dashboards
GRAFANA_DASHBOARDS_PATH := docker-compose/common/config/grafana/dashboards

dashboards_out:
	@for app in ${APPS_MIXIN}; do \
		mkdir -p "$(GRAFANA_DASHBOARDS_PATH)/$$app"; \
		cd "monitoring-mixins/$$app" && cp -f deploy/dashboards_out/* "../../$(GRAFANA_DASHBOARDS_PATH)/$$app/"; \
		cd -; \
	done