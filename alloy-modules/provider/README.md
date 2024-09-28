# Module Components

This module provides receivers components for collecting data(`logs` `metrics` `traces` `profiles`).

## Components
  - [`self_hosted_stack`](#self_hosted_stack)
  - [`grafana_cloud`](#grafana_cloud)

### `self_hosted_stack`

Module component to configure receivers for Self Hosted LGTMP Stack.

***Arguments***

| Name                    | Required | Default                             | Description                         |
|:------------------------|:---------|:------------------------------------|:------------------------------------|
| `metrics_endpoint_url`  | _no_     | `http://mimir:8080/api/v1/push`     | Where to send collected `metrics`.  |
| `logs_endpoint_url`     | _no_     | `http://loki:3100/loki/api/v1/push` | Where to send collected `logs`.     |
| `traces_endpoint_url`   | _no_     | `http://tempo:4318`                 | Where to send collected `traces`.   |
| `profiles_endpoint_url` | _no_     | `http://pyroscope:4040`             | Where to send collected `profiles`. |

***Exports***

| Name                | Type                     | Description                                                      |
|---------------------|--------------------------|------------------------------------------------------------------|
| `metrics_receiver`  | `prometheus.Interceptor` | A value that other components can use to send metrics data to.   |
| `logs_receiver`     | `loki.LogsReceiver`      | A value that other components can use to send logs data to.      |
| `traces_receiver`   | `otelcol.Consumer`       | A value that other components can use to send trace data to.     |
| `profiles_receiver` | `write.fanOutClient`     | A value that other components can use to send profiling data to. |

***Example***

```alloy
import.git "provider" {
  repository     = "https://github.com/qclaogui/codelab-monitoring.git"
  revision       = "main"
  path           = "alloy-modules/provider"
  pull_frequency = "24h"
}

// get the receivers from provider
provider.self_hosted_stack "compose" {
  metrics_endpoint_url  = "http://mimir:8080/api/v1/push"
}

// get the receivers from provider
provider.self_hosted_stack "kubernetes" {
  metrics_endpoint_url  = "http://mimir.monitoring-system.svc.cluster.local:8080/api/v1/push"
}

// scrape metrics and write to metric receiver
prometheus.scrape "default" {
  targets = [
    {"__address__" = "127.0.0.1:12345"},
  ]

  forward_to = [
    provider.self_hosted_stack.compose.metrics_receiver,
    provider.self_hosted_stack.kubernetes.metrics_receiver,
  ]
}
```

### `grafana_cloud`

Module component to automatically configure receivers for Grafana Cloud.

To create a token:

1. Navigate to the [Grafana Cloud Portal](https://grafana.com/profile/org)
2. Go to either the `Access Policies` or `API Keys` page, located in the `Security` section
3. Create an Access Policy or API token with the correct permissions

The token must have permissions to read stack information. The setup of these permissions depends on the type of token:

- Access Policies need the `stacks:read` scope
- API Keys need at least the the `MetricsPublisher` role

***Arguments***

| Name         | Required | Default | Description                                        |
|:-------------|:---------|:--------|:---------------------------------------------------|
| `stack_name` | _yes_    | `N/A`   | Name of your stack as shown in the account console |
| `token`      | _yes_    | `N/A`   | Access policy token or API Key.                    |

***Exports***

| Name                | Type                     | Description                                                                                                                  |
|---------------------|--------------------------|------------------------------------------------------------------------------------------------------------------------------|
| `metrics_receiver`  | `prometheus.Interceptor` | A value that other components can use to send metrics data to.                                                               |
| `logs_receiver`     | `loki.LogsReceiver`      | A value that other components can use to send logs data to.                                                                  |
| `traces_receiver`   | `otelcol.Consumer`       | A value that other components can use to send trace data to.                                                                 |
| `profiles_receiver` | `write.fanOutClient`     | A value that other components can use to send profiling data to.                                                             |
| `stack_information` | `object`                 | Decoded representation of the [Stack info endpoint](https://grafana.com/docs/grafana-cloud/api-reference/cloud-api/#stacks). |

***Example***

```alloy
import.git "provider" {
  repository     = "https://github.com/qclaogui/codelab-monitoring.git"
  revision       = "main"
  path           = "alloy-modules/provider"
  pull_frequency = "24h"
}

// get the receivers from provider
provider.grafana_cloud "stack_name" {
  stack_name = sys.env("GRAFANA_CLOUD_STACK_NAME")
  token      = sys.env("GRAFANA_CLOUD_TOKEN")
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
