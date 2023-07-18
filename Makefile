dashboards_out:
	cp -f monitoring-mixins/agent-flow-mixin/deploy/dashboards_out/* docker-compose/common/config/grafana/dashboards/agent-flow-mixin/
	cp -f monitoring-mixins/go-runtime-mixin/deploy/dashboards_out/* docker-compose/common/config/grafana/dashboards/go-runtime-mixin/