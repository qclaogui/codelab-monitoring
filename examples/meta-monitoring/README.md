# LGTMP Meta Monitoring

This example enabled local LGTMP Stack meta monitoring by setting `loki`,`tempo`, `mimir` and `pyroscope` 's lable `metrics.grafana.com/scrape: true`(default: false).

## Docker compose

`compose.yaml`:

```yaml
include:
# # use git remote
# - path: https://github.com/qclaogui/codelab-monitoring.git#main:docker-compose/monolithic-mode/all-in-one/compose.yaml

# # use local path
- path: ../../docker-compose/monolithic-mode/all-in-one/compose.yaml

```

`compose.override.yaml`:

```yaml
services:
  loki:
    labels:
      metrics.grafana.com/scrape: true
  tempo:
    labels:
      metrics.grafana.com/scrape: true
  mimir:
    labels:
      metrics.grafana.com/scrape: true
  pyroscope:
    labels:
      metrics.grafana.com/scrape: true

  # override included service grafana for dashboards pre-provisioning
  grafana:
    volumes:
      - ../../monitoring-mixins/loki-mixin/deploy/dashboards_out:/var/lib/grafana/dashboards/loki-mixin
      - ../../monitoring-mixins/tempo-mixin/deploy/dashboards_out:/var/lib/grafana/dashboards/tempo-mixin
      - ../../monitoring-mixins/mimir-mixin/deploy/dashboards_out:/var/lib/grafana/dashboards/mimir-mixin
      - ../../monitoring-mixins/pyroscope-mixin/deploy/dashboards_out:/var/lib/grafana/dashboards/pyroscope-mixin

  # override included service mimirtool for rules and alerts pre-provisioning
  mimirtool:
    volumes:
      - ../../monitoring-mixins/loki-mixin/deploy/loki-mixin-rules.yaml:/rules/loki-mixin-rules.yaml
      - ../../monitoring-mixins/loki-mixin/deploy/loki-mixin-alerts.yaml:/rules/loki-mixin-alerts.yaml
      - ../../monitoring-mixins/tempo-mixin/deploy/tempo-mixin-rules.yaml:/rules/tempo-mixin-rules.yaml
      - ../../monitoring-mixins/tempo-mixin/deploy/tempo-mixin-alerts.yaml:/rules/tempo-mixin-alerts.yaml
      - ../../monitoring-mixins/mimir-mixin/deploy/mimir-mixin-rules.yaml:/rules/mimir-mixin-rules.yaml
      - ../../monitoring-mixins/mimir-mixin/deploy/mimir-mixin-alerts.yaml:/rules/mimir-mixin-alerts.yaml
      - ../../monitoring-mixins/pyroscope-mixin/deploy/pyroscope-mixin-rules.yaml:/rules/pyroscope-mixin-rules.yaml
```

## Try it

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
```

Once all containers are up and running you can search for metrics in Grafana.

Navigate to [http://localhost:3000](http://localhost:3000)

## Stop services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose down
```
