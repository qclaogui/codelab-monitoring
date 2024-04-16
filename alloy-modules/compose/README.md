# Alloy Modules - Docker Compose

## Modules

- [Logs](logs/)
- [Traces](traces/)
- [Metrics](metrics/)
- [Profiles](profiles/)
- [Jobs](jobs/)
- [Integrations](integrations/)

## Compose `labels_scrape` Component for [`Logs`](logs/labels-scrape.alloy), [`Metrics`](metrics/labels-scrape.alloy) and [`Profiles`](profiles/labels-scrape.alloy)

### Logs

The following service labels are supported:

| Label            | Description |
| :--------------- | :-----------|
| `logs.grafana.com/scrape` | Allow a service to declare it's logs should be ingested (default is `true`). |
| `logs.grafana.com/tenant` | Allow a service to override the tenant for its logs. |

---

### Metrics

The following service labels are supported for gathering of metrics for docker compose services:

| Label            | Description |
| :--------------- | :-----------|
| `metrics.grafana.com/scrape` <br>or<br> `prometheus.io/scrape` | Boolean whether or not to scrape the service for metrics (default is `true`).|
| `metrics.grafana.com/scheme` <br>or<br> `prometheus.io/scheme` | The default scraping scheme is `http`, only support `http` now. |
| `metrics.grafana.com/path` <br>or<br> `prometheus.io/path` | the default path to scrape is `/metrics`, this can be specified as a single value which would override, the scrape path being used for all ports attached to the target |
| `metrics.grafana.com/port` <br>or<br> `prometheus.io/port` | the default `port` to scrape is the target port, this can be specified as a single value which would override the scrape port being used for all ports attached to the target, note that even if an target had multiple targets, the relabel_config targets are deduped before scraping |
| `metrics.grafana.com/tenant` | The tenant their metrics should be sent to, this does not necessarily have to be the actual tenantId, it can be a friendly name as well that is simply used to determine if the metrics should be gathered for the current tenant |
| `metrics.grafana.com/job` <br>or<br> `prometheus.io/job` | The job label value to use when collecting their metrics.  However, it is common to use an integration or community project where rules / dashboards are provided for you.  Oftentimes, this provided assets use hard-coded values for a job label i.e. `...{job="integrations/cadvisor"...}` or `...{job="minio-job"...}` setting this annotation to that value will allow the provided asset to work out of the box. |
| `metrics.grafana.com/interval` <br>or<br> `prometheus.io/interval` | The default interval to scrape is `15s`, this can be override. |
| `metrics.grafana.com/timeout` <br>or<br> `prometheus.io/timeout` | The default timeout for scraping is `10s`, this can be override. |

---

### Profiles

The following service labels are supported for docker compose services:

> The full list of <profile-type> supported by labels is `cpu`, `memory`, `goroutine`, `block`, `mutex` and `fgprof`:

| Label            | Description |
| :--------------- | :-----------|
| `profiles.grafana.com/service_name` <br>or<br> `pyroscope.io/service_name` | The special label `service_name` is required and must always be present. If it is not specified, will attempt to infer it from either of the following sources. in this order: <ul><li>1. `__meta_docker_container_label_profiles_grafana_com_service_name` which is a `profiles.grafana.com/service_name` service label<li>2. `__meta_docker_container_label_pyroscope_io_service_name` which is a `pyroscope.io/service_name` service label<li>3. `__meta_docker_container_name`</ul>|
| `profiles.grafana.com/<profile-type>.scrape` | Boolean whether or not to scrape. (default is `false`).|
| `profiles.grafana.com/<profile-type>.path` | The path to the profile type on the target. |
| `profiles.grafana.com/tenant` | The `tenant` to write profile to. default: (.*) |
| `profiles.grafana.com/scheme` | The default scraping scheme is `http`. |
| `profiles.grafana.com/port` | the default `port` to scrape is the target port, this can be specified as a single value which would override the scrape port being used for all ports attached to the target, note that even if an target had multiple targets, the relabel_config targets are deduped before scraping   |
| `profiles.grafana.com/interval` | The default `interval` to scrape is `30s`, this can be override. |
| `profiles.grafana.com/timeout` | The default `timeout` for scraping is `15s`, this can be override. |
