# Prom gen Exporter

Exposes metrics.

## Docker compose

`compose.yaml`:

```yaml
# ============================================================================ #
#                           prom gen                                   
# ============================================================================ #

# Usage:
#   COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
#   COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose down

# Note:
# include is available in Docker Compose version 2.20 and later, and Docker Desktop version 4.22 and later.
# docs: https://docs.docker.com/compose/multiple-compose-files/include/#include-and-overrides
include:
# use git remote
- path: https://github.com/qclaogui/codelab-monitoring.git#main:docker-compose/monolithic-mode/logs/compose.yaml

services:
  prom-gen:
    labels:
      # https://github.com/qclaogui/codelab-monitoring/blob/main/alloy-modules/compose/README.md
      metrics.grafana.com/scrape: true
      metrics.grafana.com/job: "monitoring-system/prom-gen"
      logs.grafana.com/scrape: true
    build:
      dockerfile: Dockerfile
    ports:
      - "8001:8001"
```

## Try it

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
```

Once all containers are up and running you can search for metrics in Grafana.

> In this case you can find `prom gen` metrics and logs.

Navigate to [http://localhost:3000](http://localhost:3000)

## Stop services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose down
```
