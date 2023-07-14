# Monitoring Mixins

Mixins are written in [jsonnet](https://jsonnet.org/), and are typically installed and updated with [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler).

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.


## Usage

### mimir-mixin

```shell
cd mimir-mixin

# grafana dashboards
make dashboards_out

# prometheus rules
make prom_rules.yaml

# prometheus alerts
make prom_alerts.yaml
```