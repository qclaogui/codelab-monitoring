# Grafana OnCall

Developer-friendly incident response with brilliant Slack integration.

- Collect and analyze alerts from multiple monitoring systems
- On-call rotations based on schedules
- Automatic escalations
- Phone calls, SMS, Slack, Telegram notifications

![oncall-alert-workflow](https://grafana.com/static/img/docs/oncall/oncall-alert-workflow.png)

> Add Grafana OnCall integration with monitoring system

## Docker `compose.yaml`

`compose.yaml`:

```yaml
include:
# use git remote
- path: https://github.com/qclaogui/codelab-monitoring.git#main:docker-compose/monolithic-mode/logs/compose.yaml
# use local path
# - path: ../../docker-compose/monolithic-mode/logs/compose.yaml

services:
  grafana-oncall:
    image: grafana/oncall

    ...

```

`compose.override.yaml`:

```yaml

services:
  # override included service grafana environment
  grafana:
    volumes:
      - ./config/grafana/provisioning/plugins/grafana-oncall-app.yaml:/etc/grafana/provisioning/plugins/grafana-oncall-app.yaml
      - ./config/grafana/provisioning/plugins/redis-app.yaml:/etc/grafana/provisioning/plugins/redis-app.yaml
      - ./config/grafana/provisioning/datasources/redis.yaml:/etc/grafana/provisioning/datasources/redis.yaml
    environment:
      GF_SECURITY_ADMIN_USER: oncall
      GF_SECURITY_ADMIN_PASSWORD: oncall
      GF_PLUGINS_ALLOW_LOADING_UNSIGNED_PLUGINS: grafana-oncall-app
      GF_INSTALL_PLUGINS: grafana-oncall-app v1.3.115, redis-app v2.2.1
```

## Launch services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
```

Once all containers are up and running you can search for metrics in Grafana.

> [!IMPORTANT]  
> 😞 Grafana OnCall is available for authorized users only, please sign in to proceed. For this example login credentials: `oncall`/`oncall`.

Navigate to [http://localhost:3000](http://localhost:3000)

## Stop services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose down
```
