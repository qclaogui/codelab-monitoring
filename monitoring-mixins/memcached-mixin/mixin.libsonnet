local mixin = import 'memcached-mixin/mixin.libsonnet';

mixin {
  _config+:: {
    clusterLabel: 'cluster',
  },
}