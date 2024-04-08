# LGTMP agent moudles

<https://grafana.com/docs/agent/latest/flow/concepts/modules/>

```river
import.git "provider" {
  repository     = "https://github.com/qclaogui/codelab-monitoring.git"
  revision       = "main"
  path           = "docker-compose/common/config/agent-flow/modules/provider.river"
  pull_frequency = "15m"
}

// get the receivers provider
provider.lgtmp_stack "docker_compose" {
  metrics_endpoint  = "http://mimir:8080"
}

// scrape metrics and write to grafana cloud
prometheus.scrape "default" {
  targets = [
    {"__address__" = "127.0.0.1:12345"},
  ]
  forward_to = [
    provider.lgtmp_stack.docker_compose.metrics_receiver,
  ]
}
```

```river
import.git "provider" {
  repository     = "https://github.com/qclaogui/codelab-monitoring.git"
  revision       = "main"
  path           = "docker-compose/common/config/agent-flow/modules/provider.river"
  pull_frequency = "15m"
}

// get the receivers provider
provider.grafana_cloud "stack_name" {
  stack_name = env("GRAFANA_CLOUD_STACK_NAME")
  token      = env("GRAFANA_CLOUD_STACK_TOKEN")
}

// scrape metrics and write to grafana cloud
prometheus.scrape "default" {
  targets = [
    {"__address__" = "127.0.0.1:12345"},
  ]
  forward_to = [
    provider.grafana_cloud.stack_name.metrics_receiver,
  ]
}
```
