# Kubernetes Modules

## Logs

The following pod annotations are supported:

| Annotation       | Description |
| :--------------- | :-----------|
| `logs.agent.grafana.com/scrape` | Allow a pod to declare it's logs should be dropped. |
| `logs.agent.grafana.com/tenant` | Allow a pod to override the tenant for its logs. |
| `logs.agent.grafana.com/log-format` | If specified additional processing is performed to extract details based on the specified format.  This value can be a comma-delimited list, in the instances a pod may have multiple containers.  The following formats are currently supported: <ul><li>common-log<li>donet<li>istio<li>json<li>klog<li>log4j-json<li>logfmt<li>otel<li>postgres<li>python<li>spring-boot<li>syslog<li>zerolog</ul> |
| `logs.agent.grafana.com/scrub-level` | Boolean whether or not the level should be dropped from the log message (as it is a label). |
| `logs.agent.grafana.com/scrub-timestamp` | Boolean whether or not the timestamp should be dropped from the log message (as it is metadata). |
| `logs.agent.grafana.com/scrub-nulls` | Boolean whether or not keys with null values should be dropped from json, reducing the size of the log message. |
| `logs.agent.grafana.com/scrub-empties` | Boolean whether or not keys with empty values (`"", [], {}`) should be dropped from json, reducing the size of the log message. |
| `logs.agent.grafana.com/embed-pod` | Boolean whether or not to inject the name of the pod to the end of the log message i.e. `__pod=agent-logs-grafana-agent-jrqms`. |
| `logs.agent.grafana.com/drop-info` | Boolean whether or not info messages should be dropped (default is `false`), but a pod can override this temporarily or permanently. |
| `logs.agent.grafana.com/drop-debug` | Boolean whether or not debug messages should be dropped (default is `true`), but a pod can override this temporarily or permanently. |
| `logs.agent.grafana.com/drop-trace` | Boolean whether or not trace messages should be dropped (default is `true`), but a pod can override this temporarily or permanently. |
| `logs.agent.grafana.com/mask-ssn` | Boolean whether or not to mask SSNs in the log line, if true the data will  be masked as `*SSN*salt*` |
| `logs.agent.grafana.com/mask-credit-card` | Boolean whether or not to mask credit cards in the log line, if true the data will be masked as `*credit-card*salt*` |
| `logs.agent.grafana.com/mask-email` | Boolean whether or not to mask emails in the log line, if true the data will be masked as`*email*salt*` |
| `logs.agent.grafana.com/mask-ipv4` | Boolean whether or not to mask IPv4 addresses in the log line, if true the data will be masked as`*ipv4*salt*` |
| `logs.agent.grafana.com/mask-ipv6` | Boolean whether or not to mask IPv6 addresses in the log line, if true the data will be masked as `*ipv6*salt*` |
| `logs.agent.grafana.com/mask-phone` | Boolean whether or not to mask phone numbers in the log line, if true the data will be masked as `*phone*salt*` |

---
## Metrics

The following pod annotations are supported are supported for gathering of metrics for pods and endpoints:

| Annotation       | Description |
| :--------------- | :-----------|
| `metrics.agent.grafana.com/scrape` <br> `prometheus.io/scrape` | Boolean whether or not to scrape the endpoint / pod for metrics. *Note*: If a pod exposes multiple ports, all ports would be scraped for metrics.  To limit this behavior specify the port annotation to limit the scrape to a single port. If the label `prometheus.io/service-monitor` or `metrics.agent.grafana.com/service-monitor` is set to `"false"` that is interpreted as a `scrape: "false"` |
| `metrics.agent.grafana.com/scheme` <br> `prometheus.io/scheme` | The default scraping scheme is `http`, this can be specified as a single value which would override, the schema being used for all ports attached to the endpoint / pod. |
| `metrics.agent.grafana.com/path` <br> `prometheus.io/path` | The default path to scrape is `/metrics`, this can be specified as a single value which would override, the scrape path being used for all ports attached to the endpoint / pod. |
| `metrics.agent.grafana.com/port` <br> `prometheus.io/port` | The default port to scrape is the endpoint port, this can be specified as a single value which would override the scrape port being used for all ports attached to the endpoint, note that even if aan endpoint had multiple targets, the relabel_config targets are deduped before scraping |
| `metrics.agent.grafana.com/tenant` | The tenant their metrics should be sent to, this does not necessarily have to be the actual tenantId, it can be a friendly name as well that is simply used to determine if the metrics should be gathered for the current tenant |
| `metrics.agent.grafana.com/job` | The job label value to use when collecting their metrics, this can be useful as endpoints/pods will be automatically scraped for metrics, separate jobs do not have to be defined.  However, it is common to use an integration or community project where rules / dashboards are provided for you.  Oftentimes, this provided assets use hard-coded values for a job label i.e. `...{job="integrations/kubernetes/cadvisor"...}` or `...{job="kube-state-metrics"...}` setting this annotation to that value will allow the provided asset to work out of the box. |
| `metrics.agent.grafana.com/interval` <br> `prometheus.io/interval` | The default interval to scrape is `1m`, this can be specified as a single value which would override, the scrape interval being used for all ports attached to the endpoint / pod. |
| `metrics.agent.grafana.com/timeout` <br> `prometheus.io/timeout` | The default timeout for scraping is `10s`, this can be specified as a single value which would override, the scrape interval being used for all ports attached to the endpoint / pod. |

### Probes (Blackbox)

The following service / ingress annotations are supported are supported for probes and the gathering of metrics from blackbox exporter:

| Annotation       | Description |
| :--------------- | :-----------|
| `probes.agent.grafana.com/probe` <br> `prometheus.io/probe` | Boolean whether or not to probe the service / ingress for metrics. *Note*: If a pod exposes multiple ports, all ports would be probed.  To limit this behavior specify the port annotation to limit the probe to a single port. |
| `probes.agent.grafana.com/port` <br> `prometheus.io/port` | The default port to probe is the service / ingress port, this can be specified as a single value which would override the probe port being used for all ports attached to the service / ingress, note that even if aan service / ingress had multiple targets, the relabel_config targets are deduped before scraping |
| `probes.agent.grafana.com/path` <br> `prometheus.io/path` | The default path to probe is `/metrics`, this can be specified as a single value which would override, the probe path being used for all ports attached to the service / ingress. |
| `probes.agent.grafana.com/module` <br> `prometheus.io/module` | The name of the blackbox module to use for probing the resource, the default value is "unknown" as these values should be determined from your blackbox-exporter configuration file. |
| `probes.agent.grafana.com/tenant` | The tenant their metrics should be sent to, this does not necessarily have to be the actual tenantId, it can be a friendly name as well that is simply used to determine if the metrics should be gathered for the current tenant |
| `probes.agent.grafana.com/job` | The job label value to use when collecting their metrics, this can be useful as service / ingress will be automatically probed for metrics, separate jobs do not have to be defined.  However, it is common to use an integration or community project where rules / dashboards are provided for you.  Oftentimes, this provided assets use hard-coded values for a job label i.e. `...{job="blackbox-exporter"...}` setting this annotation to that value will allow the provided asset to work out of the box. |
| `probes.agent.grafana.com/interval` | The default interval to probe is `1m`, this can be specified as a single value which would override, the probe interval being used for all ports attached to the service / ingress. |
| `probes.agent.grafana.com/timeout` | The default timeout for scraping is `10s`, this can be specified as a single value which would override, the probe interval being used for all ports attached to the service / ingress. |

### Probes (json-exporter)

The following service / ingress annotations are supported are supported for probes and the gathering of metrics from json-exporter exporter:

| Annotation       | Description |
| :--------------- | :-----------|
| `json.agent.grafana.com/probe` | Boolean whether or not to probe the service / ingress for metrics. *Note*: If a pod exposes multiple ports, all ports would be probed.  To limit this behavior specify the port annotation to limit the probe to a single port. |
| `json.agent.grafana.com/port` <br> `prometheus.io/port` | The default port to probe is the service / ingress port, this can be specified as a single value which would override the probe port being used for all ports attached to the service / ingress, note that even if aan service / ingress had multiple targets, the relabel_config targets are deduped before scraping |
| `json.agent.grafana.com/path` | The default path to probe is `/metrics`, this can be specified as a single value which would override, the probe path being used for all ports attached to the service / ingress. |
| `json.agent.grafana.com/module` | The name of the json-exporter module to use for probing the resource, the default value is "unknown" as these values should be determined from your json-exporter-exporter configuration file. |
| `json.agent.grafana.com/tenant` | The tenant their metrics should be sent to, this does not necessarily have to be the actual tenantId, it can be a friendly name as well that is simply used to determine if the metrics should be gathered for the current tenant |
| `json.agent.grafana.com/job` | The job label value to use when collecting their metrics, this can be useful as service / ingress will be automatically probed for metrics, separate jobs do not have to be defined.  However, it is common to use an integration or community project where rules / dashboards are provided for you.  Oftentimes, this provided assets use hard-coded values for a job label i.e. `...{job="json-exporter"...}` setting this annotation to that value will allow the provided asset to work out of the box. |
| `json.agent.grafana.com/interval` | The default interval to probe is `1m`, this can be specified as a single value which would override, the probe interval being used for all ports attached to the service / ingress. |
| `json.agent.grafana.com/timeout` | The default timeout for scraping is `10s`, this can be specified as a single value which would override, the probe interval being used for all ports attached to the service / ingress. |

See [/example/kubernetes/metrics](../../example/kubernetes/metrics/) for working example configurations.
