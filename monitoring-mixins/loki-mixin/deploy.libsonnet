(import 'mixin.libsonnet') + {
  // Config overrides
  _config+:: {

    // uses Grafana Alloy instead of promtail
    promtail+: {
      enabled: false,
    },

    meta_monitoring+: {
      enabled: true,
    },
  },
}
