(import 'loki-mixin/mixin.libsonnet') + {
  _config+:: {

    promtail+: {
      enabled: false,
    },

  },
}