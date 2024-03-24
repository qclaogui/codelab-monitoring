# Prometheus GitHub Exporter

Exposes basic metrics for your repositories from the GitHub API, to a Prometheus compatible endpoint.

## Docker compose

```yaml

include:
- path: https://github.com/qclaogui/codelab-monitoring.git#main:docker-compose/monolithic-mode/logs/compose.yaml

# https://github.com/qclaogui/codelab-monitoring/blob/main/docker-compose/common/config/agent-flow/modules/docker/README.md
services:
  github-exporter:
    image: githubexporter/github-exporter:latest
    environment:
    - REPOS=qclaogui/codelab-monitoring,grafana/agent

```

## Try it

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
```

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose down
```

Once all containers are up and running you can search for metrics(from Mimir) logs(from Loki) traces(from Tempo) and profiles(Pyroscope) in Grafana.

> In this case you can find `github-exporter` metrics and logs.

Navigate to [http://localhost:3000](http://localhost:3000)
