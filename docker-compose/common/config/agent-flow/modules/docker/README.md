# Docker Compose Modules

## Logs

The following service labels are supported:

| Label            | Description |
| :--------------- | :-----------|
| `logs.agent.grafana.com/scrape` | Allow a service to declare it's logs should be ingested (default is `true`). |
| `logs.agent.grafana.com/tenant` | Allow a service to override the tenant for its logs. |
| `logs.agent.grafana.com/log-format` | If specified additional processing is performed to extract details based on the specified format.  This value can be a comma-delimited list, in the instances a pod may have multiple containers.  The following formats are currently supported: <ul><li>common-log<li>donet<li>istio<li>json<li>klog<li>log4j-json<li>logfmt<li>otel<li>postgres<li>python<li>spring-boot<li>syslog<li>zerolog</ul> |
| `logs.agent.grafana.com/scrub-level` | Boolean whether or not the level should be dropped from the log message (as it is a label). |
| `logs.agent.grafana.com/scrub-timestamp` | Boolean whether or not the timestamp should be dropped from the log message (as it is metadata). |
| `logs.agent.grafana.com/scrub-nulls` | Boolean whether or not keys with null values should be dropped from json, reducing the size of the log message. |
| `logs.agent.grafana.com/scrub-empties` | Boolean whether or not keys with empty values (`"", [], {}`) should be dropped from json, reducing the size of the log message. |
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

The following service labels are supported for gathering of metrics for docker compose services:

| Label            | Description |
| :--------------- | :-----------|
| `metrics.agent.grafana.com/scrape` <br>or<br> `prometheus.io/scrape` | Boolean whether or not to scrape the service for metrics (default is `true`).|
| `metrics.agent.grafana.com/scheme` <br>or<br> `prometheus.io/scheme` | The default scraping scheme is `http`, only support `http` now. |
| `metrics.agent.grafana.com/path` <br>or<br> `prometheus.io/path` | the default path to scrape is `/metrics`, this can be specified as a single value which would override, the scrape path being used for all ports attached to the target |
| `metrics.agent.grafana.com/port` <br>or<br> `prometheus.io/port` | the default `port` to scrape is the target port, this can be specified as a single value which would override the scrape port being used for all ports attached to the target, note that even if an target had multiple targets, the relabel_config targets are deduped before scraping |
| `metrics.agent.grafana.com/tenant` | The tenant their metrics should be sent to, this does not necessarily have to be the actual tenantId, it can be a friendly name as well that is simply used to determine if the metrics should be gathered for the current tenant |
| `metrics.agent.grafana.com/job` <br>or<br> `prometheus.io/job` | The job label value to use when collecting their metrics.  However, it is common to use an integration or community project where rules / dashboards are provided for you.  Oftentimes, this provided assets use hard-coded values for a job label i.e. `...{job="integrations/kubernetes/cadvisor"...}` or `...{job="minio-job"...}` setting this annotation to that value will allow the provided asset to work out of the box. |
| `metrics.agent.grafana.com/interval` <br>or<br> `prometheus.io/interval` | The default interval to scrape is `15s`, this can be override. |
| `metrics.agent.grafana.com/timeout` <br>or<br> `prometheus.io/timeout` | The default timeout for scraping is `10s`, this can be override. |
