# Monitoring Mixins

> Provisioning Grafana `dashboards` Prometheus `rules` and `alerts`

Mixins are written in [jsonnet](https://jsonnet.org/), and are typically installed and updated with [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler).

For more advanced uses of mixins, see
<https://github.com/monitoring-mixins/docs>.

## Example

### github-mixin

```bash
mkdir github-mixin && cd github-mixin

```

1 Initialise Jsonnet

``` bash
jb init
```

2 Install Github mixin

<https://github.com/rgeyer/github-exporter>

``` bash
jb install github.com/rgeyer/github-exporter/github-mixin@master
```

3 Import and configure it

``` bash
(import 'github-mixin/mixin.libsonnet') + {
  _config+:: {
    // Override the config here.
  },
}
```
