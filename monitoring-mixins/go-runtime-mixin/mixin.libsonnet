{
  grafanaDashboards: {
    'go-runtime.json': (import 'dashboards/go-runtime.json') {
      uid: std.md5('go-runtime.json'),
    },
  },
  prometheusRules: {},
  prometheusAlerts: {},
}
