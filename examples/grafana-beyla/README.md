# Grafana Beyla

Open source zero-code automatic instrumentation with eBPF and OpenTelemetry.

## Docker compose

`compose.yaml`:

```yaml
include:
- path: ../../docker-compose/monolithic-mode/traces/compose.yaml

services:
  # Beyla for NGINX gateway
  gateway-beyla:
    depends_on: { gateway: { condition: service_started } }
    image: grafana/beyla:1.5.3
    volumes:
      - ./beyla/beyla-config.yml/:/configs/beyla-config.yml
      - ./sys-kernel-security:/sys/kernel/security
    privileged: true 
    network_mode: "service:gateway"
    pid: "service:gateway"
    environment:
      BEYLA_CONFIG_PATH: "/configs/beyla-config.yml"
      BEYLA_OPEN_PORT: "8080,3100,3200"
      BEYLA_SERVICE_NAMESPACE: "monitoring-system"
      OTEL_SERVICE_NAME: "gateway"
      OTEL_EXPORTER_OTLP_ENDPOINT: "http://alloy:4318"

```

`compose.override.yaml`:

```yaml
services:
  # override included service grafana for dashboards pre-provisioning
  grafana:
    volumes:
      - ./beyla/beyla-red-metrics.json:/var/lib/grafana/dashboards/beyla-red-metrics.json
    environment:
      GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH: /var/lib/grafana/dashboards/beyla-red-metrics.json
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

## Helpful Links

- <https://github.com/grafana/beyla>
