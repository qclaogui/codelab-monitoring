(import "mixin.libsonnet") +{
  // Config overrides
  _config+:: {
    kubeApiserverSelector: 'job="integrations/kubernetes/apiserver"',
    cadvisorSelector: 'job="integrations/kubernetes/cadvisor"',
    kubeletSelector: 'job="integrations/kubernetes/kubelet"',
    kubeStateMetricsSelector: 'job="integrations/kubernetes/kube-state-metrics"',
    nodeExporterSelector: 'job="integrations/kubernetes/node-exporter"',
    kubeSchedulerSelector: 'job="kube-scheduler"',
    kubeControllerManagerSelector: 'job="kube-controller-manager"',
    kubeProxySelector: 'job="kube-proxy"',

    grafanaK8s+:: {
      dashboardNamePrefix: 'Kubernetes / ',
      dashboardTags: ['kubernetes-mixin', 'infrastucture'],
      grafanaTimezone: 'browser',
    },

    // Opt-in to multiCluster dashboards by overriding this and the clusterLabel.
    showMultiCluster: true,
    // Default datasource name
    datasourceName: 'Metrics',
  },
}