

1. Initialise Jsonnet

``` bash
jb init
```

2. Install Grafana Mimir mixin

``` bash
jb install github.com/grafana/mimir/operations/mimir-mixin@main
```

3. Import and configure it

``` bash
(import 'github.com/grafana/mimir/operations/mimir-mixin/mixin.libsonnet') + {
  _config+:: {
    // Override the Grafana Mimir mixin config here.
  },
}
```
