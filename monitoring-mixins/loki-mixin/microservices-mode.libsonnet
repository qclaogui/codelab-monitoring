(import 'mixin.libsonnet') + {
  _config+:: {

    promtail+: {
      enabled: false,
    },

    thanos: {
      // Whether or not to include thanos specific dashboards
      enabled: false,
    },
    
  },
}
