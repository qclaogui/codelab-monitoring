(import 'mixin.libsonnet') + {
    // Config overrides
    _config+:: {
      jobs: {
        gateway: 'cortex-gw(-internal)?',
        query_frontend: '(tempo|query-frontend)',
        querier: '(tempo|querier)',
        ingester: '(tempo|ingester)',
        metrics_generator: '(tempo|metrics-generator)',
        distributor: '(tempo|distributor)',
        compactor: '(tempo|compactor)',
        block_builder: '(tempo|block-builder)',
        backend_scheduler: 'backend-scheduler',
        backend_worker: 'backend-worker',
        memcached: 'memcached',
      }
    }
}