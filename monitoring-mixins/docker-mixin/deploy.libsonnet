(import 'mixin.libsonnet') + {
  // Config overrides
  _config+:: {
    dashboardTags: ['docker'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    enableLokiLogs: true,
  },
}
