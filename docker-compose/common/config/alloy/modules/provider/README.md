# Receivers Provider Moudle

Provide the receivers of the collected data(`logs` `metrics` `traces` `profiles`).

## Components

- [self_hosted](#self_hosted)
- [grafana_cloud](#grafana_cloud)

### `self_hosted`

Module to configure receivers for Self Hosted LGTMP Stack.

***Arguments***

| Name                | Required | Default | Description                                        |
| :------------------ | :------- | :---------------------- | :--------------------------------- |
| `metrics_endpoint`  | _no_     | `http://mimir:8080`     | Where to send collected `metrics`. |
| `logs_endpoint`     | _no_     | `http://loki:3100`      | Where to send collected `logs`.    |
| `traces_endpoint`   | _no_     | `tempo:4317`            | Where to send collected `traces`.  |
| `profiles_endpoint` | _no_     | `http://pyroscope:4040` | Where to send collected `profiles`.|

***Exports***

| Name                |        Type              | Description                                                                 |
| --------------------| ------------------------ | --------------------------------------------------------------------------- |
| `metrics_receiver`  | `prometheus.Interceptor` | A value that other components can use to send metrics data to.              |
| `logs_receiver`     | `loki.LogsReceiver`      | A value that other components can use to send logs data to.                 |
| `traces_receiver`   | `otelcol.Consumer`       | A value that other components can use to send trace data to.                |
| `profiles_receiver` | `write.fanOutClient`     | A value that other components can use to send profiling data to.            |

***Example***

```alloy
import.git "provider" {
  repository     = "https://github.com/qclaogui/codelab-monitoring.git"
  revision       = "main"
  path           = "docker-compose/common/config/alloy/modules/provider"
  pull_frequency = "15m"
}

// get the receivers from provider
provider.self_hosted "compose" {
  metrics_endpoint  = "http://mimir:8080"
}

// get the receivers from provider
provider.self_hosted "kubernetes" {
  metrics_endpoint  = "http://mimir.monitoring-system.svc.cluster.local:8080"
}

// scrape metrics and write to metric receiver
prometheus.scrape "default" {
  targets = [
    {"__address__" = "127.0.0.1:12345"},
  ]

  forward_to = [
    provider.self_hosted.compose.metrics_receiver,
    provider.self_hosted.kubernetes.metrics_receiver,
  ]
}
```

### `grafana_cloud`

Module to automatically configure receivers for Grafana Cloud.

To create a token:

1. Navigate to the [Grafana Cloud Portal](https://grafana.com/profile/org)
2. Go to either the `Access Policies` or `API Keys` page, located in the `Security` section
3. Create an Access Policy or API token with the correct permissions

The token must have permissions to read stack information. The setup of these permissions depends on the type of token:

- Access Policies need the `stacks:read` scope
- API Keys need at least the the `MetricsPublisher` role

***Arguments***

| Name         | Required | Default | Description                                        |
| :----------- | :------- | :------ | :------------------------------------------------- |
| `stack_name` | _yes_    | `N/A`   | Name of your stack as shown in the account console |
| `token`      | _yes_    | `N/A`   | Access policy token or API Key.                    |

***Exports***

| Name                |        Type              | Description                                                                 |
| --------------------| ------------------------ | --------------------------------------------------------------------------- |
| `metrics_receiver`  | `prometheus.Interceptor` | A value that other components can use to send metrics data to.              |
| `logs_receiver`     | `loki.LogsReceiver`      | A value that other components can use to send logs data to.                 |
| `traces_receiver`   | `otelcol.Consumer`       | A value that other components can use to send trace data to.                |
| `profiles_receiver` | `write.fanOutClient`     | A value that other components can use to send profiling data to.            |
| `stack_information` | `object`                 | Decoded representation of the [Stack info endpoint](https://grafana.com/docs/grafana-cloud/api-reference/cloud-api/#stacks). |

***Example***

```alloy
import.git "provider" {
  repository     = "https://github.com/qclaogui/codelab-monitoring.git"
  revision       = "main"
  path           = "docker-compose/common/config/alloy/modules/provider"
  pull_frequency = "15m"
}

// get the receivers from provider
provider.grafana_cloud "stack_name" {
  stack_name = env("GRAFANA_CLOUD_STACK_NAME")
  token      = env("GRAFANA_CLOUD_STACK_TOKEN")
}

// scrape metrics and write to metric receiver
prometheus.scrape "default" {
  targets = [
    {"__address__" = "127.0.0.1:12345"},
  ]
  forward_to = [
    provider.grafana_cloud.stack_name.metrics_receiver,
  ]
}
```
