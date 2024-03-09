# Kubernetes Metrics Jobs

The following jobs are completely isolated and have no dependencies on other modules.  Overall, they should be more performant than relying on dependencies of other modules as they are designed to complete a specific task.

## Job Modules

- [Agent](#agent)
- [Annotations Probe](#annotations-probe)
- [Annotations Scrape](#annotation-scrape)
- [cAdvisor](#cadvisor)
- [Cert Manager](#cert-manager)
- [Consul](#consul)
- [Etcd](#etcd)
- [Gitlab Exporter](#gitlab-exporter)
- [Grafana](#grafana)
- [HAProxy](#haproxy)
- [Kube ApiServer](#kube-apiserver)
- [Kube Probes](#kube-probes)
- [Kube Proxy](#kube-proxy)
- [Kube Resource](#kube-resource)
- [Kube State Metrics](#kube-state-metrics)
- [Kubelet](#kubelet)
- [Loki](#loki)
- [Memcached](#memcached)
- [Mimir](#mimir)
- [Mysql](#mysql)
- [Node Exporter](#node-exporter)
- [OpenCost](#opencost)
- [Prometheus Operator](#prometheus-operator)
- [Push Gateway](#push-gateway)
- [RabbitMQ](#rabbitmq)
- [Redis](#redis)
- [Statsd](#Statsd)
- [Tempo](#tempo)

### Agent

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the grafana-agent job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=grafana-agent"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http-metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/agent` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./agent.river#L170) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Annotations Probe

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `role` | `false` | `service` | The role to use when looking for targets to scrape via annotations, can be: service or ingress |
| `blackbox_url` | `false` | `""` | The address of the blackbox exporter to use (without the protocol), only the hostname and port i.e. blackbox-prometheus-blackbox-exporter.default.svc.cluster.local:9115 |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `[]` | The label selectors to use to find matching targets |
| `annotation` | `false` | `probes.grafana.com` | The annotation namespace to use |
| `tenant` | `false` | `.*` | The tenant to write metrics to.  This does not have to be the tenantId, this is the value to look for in the pro0bes.grafana.com/tenant annotation, and this can be a regex. |
| `keep_metrics` | `false` | `(.+)` | A regex of metrics to keep |
| `drop_metrics` | `false` | `""` | A regex of metrics to drop |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Annotations Scrape

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `role` | `false` | `service` | The role to use when looking for targets to scrape via annotations, can be: service or ingress |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `[]` | The label selectors to use to find matching targets |
| `annotation` | `false` | `probes.grafana.com` | The annotation namespace to use |
| `tenant` | `false` | `.*` | The tenant to write metrics to.  This does not have to be the tenantId, this is the value to look for in the pro0bes.grafana.com/tenant annotation, and this can be a regex. |
| `keep_metrics` | `false` | `(.+)` | A regex of metrics to keep |
| `drop_metrics` | `false` | `""` | A regex of metrics to drop |
| `scrape_port_named_metrics` | `false` | Whether or not to automatically scrape endpoints that have a port with 'metrics' in the name |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### cAdvisor

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the cAdvisor job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `job_label` | `false` | `integrations/kubernetes/cadvisor` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./cadvisor.river#L115) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Cert Manager

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the cert-manager should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=cert-manager"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http-metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/cert-manager` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./cert-manager.river#L183) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Consul

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the consul should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app=consul"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http-metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/consul` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./consul.river#L183) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Etcd

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the etcd should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/component=etcd"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/consul` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./etcd.river#L183) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Gitlab Exporter

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the gitlab-exporter should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=gitlab-ci-pipelines-exporter"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/gitlab` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./gitlab.river#L128) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Grafana

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the grafana should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=grafana"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http-metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/gitlab` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./agent.river#L128) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### HAProxy

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the haproxy should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/component=haproxy"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `prometheus` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/haproxy` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./haproxy.river#L183) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Kube ApiServer

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the Kube ApiServer job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespace` | `false` | `default` | The namespaces to look for targets in |
| `service` | `false` | `kubernetes` | The label to use for the selector |
| `port_name` | `false` | `https` | The value of the label for the selector |
| `job_label` | `false` | `integrations/kubernetes/kube-apiserver` | The job label to add for all kube-apiserver metric |
| `drop_metrics` | `false` | [see module](./kube-apiserver.river#L153) | A regex of metrics to drop |
| `drop_les` | `false` | [see module](./kube-apiserver.river#163) | Regex of metric les label values to drop |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Kube Probes

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the Kube Probes job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `job_label` | `false` | `integrations/kubernetes/kube-probes` | The job label to add for all kube-probe metric |
| `keep_metrics` | `false` | [see module](./kube-probes.river#L117) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Kube Proxy

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the Kube Proxy job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespace` | `false` | `kube-system` | The namespaces to look for targets in |
| `selectors` | `false` | `["component=kube-proxy"]` | The label selectors to use to find matching targets |
| `port` | `false` | `10249` | The port to scrape kube-proxy metrics on |
| `job_label` | `false` | `integrations/kubernetes/kube-proxy` | The job label to add for all kube-apiserver metric |
| `keep_metrics` | `false` | [see module](./kube-proxy.river#L124) | A regex of metrics to drop |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Kube Resource

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the Kube Resources job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `job_label` | `false` | `integrations/kubernetes/kube-resources` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./kube-resource.river#L117) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Kube State Metrics

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the kube-state-metrics job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=kube-state-metrics"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http-metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/kubenetes/kube-state-metrics` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./kube-state-metrics.river#L127) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Kubelet

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the Kubelet job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `job_label` | `false` | `integrations/kubernetes/kubelet` | The job label to add for all kube-probe metric |
| `keep_metrics` | `false` | [see module](./kubelet.river#L116) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Loki

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the Loki job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=loki"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http-metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/loki` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./loki.river#L186) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Memcached

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the Memcached job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=memcached"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/memcached` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./memcached.river#L170) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Mimir

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the Mimir job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=mimir"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http-metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/mimir` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./mimir.river#L186) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Mysql

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the haproxy should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=prometheus-mysql-exporter"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/mysql` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./mysql.river#L183) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Node Exporter

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the Node Exporter job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=prometheus-node-exporter"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/node_exporter` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./node-exporter.river#L141) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### OpenCost

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the OpenCost job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=opencost"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/kubernetes/opencost` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./opencost.river#L123) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Prometheus Operator

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `namespaces` | `false` | `[]` | List of namespaces to search for prometheus operator resources in |
| `servicemonitor_namespaces` | `false` | `[]` | List of namespaces to search for just servicemonitors resources in |
| `podmonitor_namespaces` | `false` | `[]` | List of namespaces to search for just podmonitors resources in |
| `probe_namespaces` | `false` | `[]` | List of namespaces to search for just probes resources in |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Push Gateway

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the pushgateway should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=prometheus-pushgateway"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/push-gateway` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./push-gateway.river#L183) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### RabbitMQ

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the rabbitmq should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=rabbitmq-exporter"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `rabbitmq-exporter` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/rabbitmq` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./rabbitmq.river#L183) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Redis

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the redis should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=prometheus-redis-exporter"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `redis-exporter` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/redis` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./redis.river#L183) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Statsd

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the statsd should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=prometheus-statsd-exporter"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/statsd` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./redis.river#L183) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |

---

### Tempo

| Argument | Required | Default | Description |
| :------- | :------- | :-------| :---------- |
| `forward_to` | `true` | _NA_ | Must be a list(MetricsReceiver) where collected logs should be forwarded to |
| `enabled` | `false` | `true` | Whether or not the Tempo job should be enabled, this is useful for disabling the job when it is being consumed by other modules in a multi-tenancy environment |
| `namespaces` | `false` | `[]` | The namespaces to look for targets in (`[]` is all namespaces) |
| `selectors` | `false` | `["app.kubernetes.io/name=tempo"]` | The label selectors to use to find matching targets |
| `port_name` | `false` | `http-metrics` | The of the port to scrape metrics from |
| `job_label` | `false` | `integrations/tempo` | The job label to add for all metrics |
| `keep_metrics` | `false` | [see module](./tempo.river#L183) | A regex of metrics to keep |
| `scrape_interval` | `false` | `60s` | How often to scrape metrics from the targets |
| `scrape_timeout` | `false` | `10s` | How long before a scrape times out |
| `max_cache_size` | `false` | `100000` | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering` | `false` | `false` | Whether or not clustering should be enabled |
