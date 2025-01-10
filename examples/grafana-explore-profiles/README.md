# Grafana Explore Profiles App

Explore Profiles is a native Grafana application designed to integrate seamlessly with Pyroscope, the open-source continuous profiling platform, providing a smooth, query-less experience for browsing and analyzing profiling data.

## Docker `compose.yaml`

`compose.yaml`:

```yaml
include:
- path: https://github.com/qclaogui/codelab-monitoring.git#main:docker-compose/monolithic-mode/profiles/compose.yaml

```

`compose.override.yaml`:

```yaml
services:
  # override included service grafana environment
  grafana:
    image: ${GRAFANA_IMAGE:-docker.io/grafana/grafana:11.4.0}
    volumes:
      - ./grafana/provisioning/plugins/grafana-pyroscope-app.yaml:/etc/grafana/provisioning/plugins/grafana-pyroscope-app.yaml
    environment:
      GF_FEATURE_TOGGLES_ENABLE: accessControlOnCall
      GF_PLUGINS_ALLOW_LOADING_UNSIGNED_PLUGINS: grafana-pyroscope-app
      GF_INSTALL_PLUGINS: grafana-pyroscope-app

```

## Launch services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
```

Once all containers are up and running you can search for profiles in Grafana.

Navigate to <http://localhost:3000/a/grafana-pyroscope-app/explore> in order to use Explore Profiles.

## Stop services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose down
```

## Helpful Links

- <https://github.com/grafana/explore-profiles>
