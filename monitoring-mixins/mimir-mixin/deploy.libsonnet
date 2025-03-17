(import 'mixin.libsonnet') + {
  // Config overrides used when building the multiple version of the mimir-mixin.
  _config+:: {
    dashboard_datasource: 'Metrics',

    // Whether resources dashboards are enabled (based on cAdvisor metrics).
    resources_dashboards_enabled: true,
    container_names: {
      gateway: '(gateway|cortex-gw|cortex-gw-internal)',
      distributor: '(mimir|distributor|mimir-write)',
      ingester: '(mimir|ingester|mimir-write)',
      query_frontend: '(mimir|query-frontend|mimir-read)',
      query_scheduler: '(mimir|query-scheduler|mimir-backend)',
      querier: '(mimir|querier|mimir-read)',
      store_gateway: '(mimir|store-gateway|mimir-backend)',
      ruler: '(mimir|ruler|mimir-backend)',
      ruler_query_frontend: '(mimir|ruler-query-frontend)',
      ruler_query_scheduler: '(mimir|ruler-query-scheduler)',
      ruler_querier: '(mimir|ruler-querier)',
      alertmanager: '(mimir|alertmanager)',
      alertmanager_im: '(mimir|alertmanager-im)',
      compactor: '(mimir|compactor|mimir-backend)',
      
      mimir_write: '(mimir|mimir-write|distributor|ingester)',
      mimir_read: '(mimir|mimir-read|query-frontend|querier|ruler-query-frontend|ruler-querier)',
      mimir_backend: '(mimir|mimir-backend|query-scheduler|ruler-query-scheduler|ruler|store-gateway|compactor|alertmanager|overrides-exporter)',
      write: '(mimir|mimir-write|distributor|ingester)',
      read: '(mimir|mimir-read|query-frontend|querier|ruler-query-frontend|ruler-querier)',
      backend: '(mimir|mimir-backend|query-scheduler|ruler-query-scheduler|ruler|store-gateway|compactor|alertmanager|overrides-exporter)',
    },

    job_names: {
      ingester: ['ingester.*', 'cortex', 'mimir', 'mimir-write.*'],  // Match also custom and per-zone ingester deployments.
      ingester_partition: ['ingester.*-partition'],  // Match exclusively temporarily partition ingesters run during the migration to ingest storage.
      block_builder: ['block-builder.*'],
      distributor: ['distributor.*', 'cortex', 'mimir', 'mimir-write.*'],  // Match also per-zone distributor deployments.
      querier: ['querier.*', 'cortex', 'mimir', 'mimir-read.*'],  // Match also custom querier deployments.
      ruler_querier: ['ruler-querier.*'],  // Match also custom querier deployments.
      ruler: ['ruler', 'cortex', 'mimir', 'mimir-backend.*'],
      query_frontend: ['query-frontend.*', 'cortex', 'mimir', 'mimir-read.*'],  // Match also custom query-frontend deployments.
      ruler_query_frontend: ['ruler-query-frontend.*'],  // Match also custom ruler-query-frontend deployments.
      query_scheduler: ['query-scheduler.*', 'mimir-backend.*'],  // Not part of single-binary. Match also custom query-scheduler deployments.
      ruler_query_scheduler: ['ruler-query-scheduler.*'],  // Not part of single-binary. Match also custom query-scheduler deployments.
      ring_members: ['admin-api', 'alertmanager', 'compactor.*', 'distributor.*', 'ingester.*', 'querier.*', 'ruler', 'ruler-querier.*', 'store-gateway.*', 'cortex', 'mimir', 'mimir-write.*', 'mimir-read.*', 'mimir-backend.*'],
      store_gateway: ['store-gateway.*', 'cortex', 'mimir', 'mimir-backend.*'],  // Match also per-zone store-gateway deployments.
      gateway: ['gateway', 'cortex-gw.*'],  // Match also custom and per-zone gateway deployments.
      compactor: ['compactor.*', 'cortex', 'mimir', 'mimir-backend.*'],  // Match also custom compactor deployments.
      alertmanager: ['alertmanager', 'cortex', 'mimir', 'mimir-backend.*'],
      overrides_exporter: ['overrides-exporter', 'cortex', 'mimir', 'mimir-backend.*'],

      // The following are job matchers used to select all components in the read path.
      main_read_path: std.uniq(std.sort(self.query_frontend + self.query_scheduler + self.querier)),
      remote_ruler_read_path: std.uniq(std.sort(self.ruler_query_frontend + self.ruler_query_scheduler + self.ruler_querier)),
    },

    instance_names: {
      gateway: '(gateway|cortex-gw|cortex-gw-internal)',
      compactor: '(.*mimir-)?(mimir|compactor|mimir-backend).*',
      distributor: '(.*mimir-)?(mimir|distributor|mimir-write).*',
      ingester: '(.*mimir-)?(mimir|ingester|mimir-write).*',
      query_frontend: '(.*mimir-)?(mimir|query-frontend|mimir-read).*',
      query_scheduler: '(.*mimir-)?(mimir|query-scheduler|mimir-backend).*',
      querier: '(.*mimir-)?(mimir|querier|mimir-read).*',
      store_gateway: '(.*mimir-)?(mimir|store-gateway|mimir-backend).*',
      ruler: '(.*mimir-)?(mimir|ruler|mimir-backend).*',
      ruler_query_frontend: '(.*mimir-)?(mimir|ruler-query-frontend).*',
      ruler_query_scheduler: '(.*mimir-)?(mimir|ruler-query-scheduler).*',
      ruler_querier: '(.*mimir-)?(mimir|ruler-querier|mimir-backend).*',
      alertmanager: '(.*mimir-)?(mimir|alertmanager|mimir-backend).*',
      alertmanager_im: '(.*mimir-)?(mimir|alertmanager-im|mimir-backend).*',
      overrides_exporter: '(.*mimir-)?(mimir|overrides-exporter|mimir-backend).*',

      mimir_write: '(.*mimir-)?(mimir|distributor|ingester|mimir-write).*',
      mimir_read: '(.*mimir-)?(mimir|mimir-read|query-frontend|querier|ruler-query-frontend|ruler-querier).*',
      mimir_backend: '(.*mimir-)?(mimir|mimir-backend|query-scheduler|ruler-query-scheduler|ruler|store-gateway|compactor|alertmanager|overrides-exporter).*',

      write: '(.*mimir-)?(mimir|distributor|ingester|mimir-write).*',
      read: '(.*mimir-)?(mimir|mimir-read|query-frontend|querier|ruler-query-frontend|ruler-querier).*',
      backend: '(.*mimir-)?(mimir|mimir-backend|query-scheduler|ruler-query-scheduler|ruler|store-gateway|compactor|alertmanager|overrides-exporter).*',
      remote_ruler_read: '(.*mimir-)?(mimir|mimir-backend|ruler_query_frontend|ruler-query-scheduler|ruler|ruler_querier).*',
    },
  },
}
