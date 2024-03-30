# Grafana OnCall

Developer-friendly incident response with brilliant Slack integration.

- Collect and analyze alerts from multiple monitoring systems
- On-call rotations based on schedules
- Automatic escalations
- Phone calls, SMS, Slack, Telegram notifications

![oncall-alert-workflow](https://grafana.com/static/img/docs/oncall/oncall-alert-workflow.png)

> Add Grafana OnCall integration with monitoring system

## Docker `compose.yaml`

```yaml
# Note:
# include is available in Docker Compose version 2.20 and later, and Docker Desktop version 4.22 and later.
# docs: https://docs.docker.com/compose/multiple-compose-files/include/#include-and-overrides
include:
- path:
    - https://github.com/qclaogui/codelab-monitoring.git#main:docker-compose/monolithic-mode/logs/compose.yaml
    - ./compose.override.yaml

services:
  grafana-oncall:
    image: grafana/oncall

    ...

```

## Launch services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
```

> 😞 Grafana OnCall is available for authorized users only, please sign in to proceed.
> default log in credentials: `oncall`/`oncall`

Navigate to [http://localhost:3000](http://localhost:3000)

## Stop services

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose down
```
