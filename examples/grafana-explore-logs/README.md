# Grafana Explore Logs App

Explore Logs offers a query-less experience for browsing Loki logs without the need for writing complex queries. Discover or narrow down your search by using by volume and text patterns. Uncover related logs and and understand patterns—all with just a few clicks. No LogQL required! With Explore Logs, you can:

- Easily find logs and log volumes for all of your services
- Effortlessly filter service logs based on their log volumes, labels, fields, or patterns.
- Automatically choose the best visualization for your log data based on its characteristics, without any manual setup.

...all without crafting a single query!

![service_index](https://github.com/grafana/explore-logs/raw/main/src/img/service_index.png)

## Docker `compose.yaml`

`compose.yaml`:

```yaml
include:
- path: https://github.com/qclaogui/codelab-monitoring.git#main:docker-compose/monolithic-mode/logs/compose.yaml

```

`compose.override.yaml`:

```yaml
services:
  # override included service grafana environment
  grafana:
    image: ${GRAFANA_IMAGE:-docker.io/grafana/grafana:11.1.3}
    volumes:
      - ./grafana/provisioning/plugins/grafana-lokiexplore-app.yaml:/etc/grafana/provisioning/plugins/grafana-lokiexplore-app.yaml
    environment:
      GF_FEATURE_TOGGLES_ENABLE: accessControlOnCall
      GF_PLUGINS_ALLOW_LOADING_UNSIGNED_PLUGINS: grafana-lokiexplore-app
      GF_INSTALL_PLUGINS: https://storage.googleapis.com/integration-artifacts/grafana-lokiexplore-app/grafana-lokiexplore-app-latest.zip;grafana-lokiexplore-app

```

## Launch services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
```

Once all containers are up and running you can search for logs in Grafana.

Navigate to <http://localhost:3000/a/grafana-lokiexplore-app/explore> in order to use Explore Logs.

## Stop services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose down
```

## Helpful Links

- <https://github.com/grafana/explore-logs>
