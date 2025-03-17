(import 'mixin.libsonnet') + {
  // Config overrides
  _config+:: {

    // uses Grafana Alloy instead of promtail
    promtail+: {
      enabled: false,
    },

    operational: {
      // Whether or not to include memcached in the operational dashboard
      memcached: true,
      // Whether or not to include consul in the operational dashboard
      consul: false,
      // Whether or not to include big table in the operational dashboard
      bigTable: false,
      // Whether or not to include dynamo in the operational dashboard
      dynamo: false,
      // Whether or not to include gcs in the operational dashboard
      gcs: false,
      // Whether or not to include s3 in the operational dashboard
      s3: true,
      // Whether or not to include azure blob in the operational dashboard
      azureBlob: false,
      // Whether or not to include bolt db in the operational dashboard
      boltDB: true,
    },

    meta_monitoring+: {
      enabled: true,
    },
  },
}
