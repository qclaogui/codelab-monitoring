# Alloy LGTMP Stack Receivers Provider Moudles

<https://grafana.com/docs/alloy/latest/concepts/modules/>

## Self Hosted LGTMP Stack Provider

```alloy
import.git "provider" {
  repository     = "https://github.com/qclaogui/codelab-monitoring.git"
  revision       = "main"
  path           = "docker-compose/common/config/alloy/modules/provider"
  pull_frequency = "15m"
}

// get the receivers from docker compose
provider.self_hosted "compose" {
  metrics_endpoint  = "http://mimir:8080"
}

// get the receivers from kubernetes
provider.self_hosted "kubernetes" {
  metrics_endpoint  = "http://mimir.monitoring-system.svc.cluster.local:8080"
}

// scrape metrics and write to grafana cloud
prometheus.scrape "default" {
  targets = [
    {"__address__" = "127.0.0.1:12345"},
  ]
  forward_to = [
    provider.self_hosted.compose.metrics_receiver,
    // provider.self_hosted.kubernetes.metrics_receiver,
  ]
}
```

## Grafana Cloud LGTMP Stack Provider

```alloy
import.git "provider" {
  repository     = "https://github.com/qclaogui/codelab-monitoring.git"
  revision       = "main"
  path           = "docker-compose/common/config/alloy/modules/provider"
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
