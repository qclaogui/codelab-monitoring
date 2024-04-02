# Prometheus GitHub Exporter

Exposes basic metrics for your repositories from the GitHub API, to a Prometheus compatible endpoint.

## Docker compose

`compose.yaml`:

```yaml
include:
# use git remote
- path: https://github.com/qclaogui/codelab-monitoring.git#main:docker-compose/monolithic-mode/logs/compose.yaml
# use local path
# - path: ../../docker-compose/monolithic-mode/logs/compose.yaml

services:
  github-exporter:
    labels:
      metrics.agent.grafana.com/scrape: true
    image: githubexporter/github-exporter:1.1.0
    environment:
    - REPOS=grafana/agent
```

`compose.override.yaml`:

```yaml
services:
  # override included service grafana for dashboards pre-provisioning
  grafana:
    volumes:
      - ../../monitoring-mixins/github-mixin/deploy/dashboards_out:/var/lib/grafana/dashboards/github-mixin

  # override included service mimirtool for rules and alerts pre-provisioning
  mimirtool:
    volumes:
      - ../../monitoring-mixins/github-mixin/deploy/github-mixin-rules.yaml:/rules/github-mixin-rules.yaml
      - ../../monitoring-mixins/github-mixin/deploy/github-mixin-alerts.yaml:/rules/github-mixin-alerts.yaml
```

## Try it

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
```

Once all containers are up and running you can search for metrics in Grafana.

> In this case you can find `github-exporter` metrics and logs.

Navigate to [http://localhost:3000](http://localhost:3000)

## Stop services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose down
```
