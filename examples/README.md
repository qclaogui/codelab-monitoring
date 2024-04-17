# Examples

This directory contains examples, including:

- [github-exporter-with-mixin](./ghe-with-mixin)
- [github-exporter-with-simple-dashboards](./ghe-with-simple-dashboards)
- [github-exporter](./github-exporter)
- [grafana-oncall-integration](./grafana-oncall)
- [grafana-explore-logs](./grafana-explore-logs)

## Debug info

`alloy` target Label Scrape by [label](../alloy-modules/compose/README.md#compose-labels_scrape-component):

<http://localhost:12345/component/metrics.labels_scrape.compose/prometheus.scrape.pc_docker_metrics>

## Grafana LGTMP Stack default port-mapping

| Port-mapping | Component | Description |
| --- | --- | --- |
| `12345:12345`, `4317`, `4318`, `6831` | [Alloy][1] | Eexpose `12345` port so we can directly access `alloy` inside container |
| `33100:3100` | [Loki][2] | Expose `33100` port so we can directly access `loki` inside container |
| `3000:3000`, `6060` | [Grafana][3] | Expose `3000` port so we can directly access `grafana` inside container |
| `33200:3200`, `4317`, `4318` | [Tempo][4] | Expose `33200` port so we can directly access `tempo` inside container |
| `38080:8080` | [Mimir][5] | Expose `38080` port so we can directly access `mimir` inside container |
| `34040:4040` | [Pyroscope][6] | Expose `34040` port so we can directly access `pyroscope` inside container |
| `9001:9001`, `9000` | [Minio][7] | Expose `9001` port so we can access `minio` console with `MINIO_ROOT_USER=lgtmp`, `MINIO_ROOT_PASSWORD=supersecret` |
| `39000:9000`, `2500`, `1100` | [Inbucket][8] | Expose `39000` port to use for the email testing server web interface. |

[1]: https://github.com/grafana/alloy
[2]: https://github.com/grafana/loki
[3]: https://github.com/grafana/grafana
[4]: https://github.com/grafana/tempo
[5]: https://github.com/grafana/mimir
[6]: https://github.com/grafana/pyroscope
[7]: https://github.com/minio/minio
[8]: https://github.com/inbucket/inbucket

## Resource Utilization

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose stats
```

```shell
CONTAINER ID   NAME                         CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O         PIDS
613d8d5e7e30   root-alloy-1                 2.72%     180.7MiB / 1.889GiB   9.34%     1.46MB / 4.61MB   3.15MB / 1.56MB   11
53443e6d4c31   root-gateway-1               0.00%     8.102MiB / 1.889GiB   0.42%     497kB / 503kB     6.45MB / 20.5kB   3
750ace278979   root-mimir-1                 1.06%     121.2MiB / 1.889GiB   6.27%     5.09MB / 888kB    111kB / 8.7MB     8
acb81816e078   root-loki-1                  1.11%     83.13MiB / 1.889GiB   4.30%     157kB / 336kB     56.2MB / 340kB    8
f5f28089da9c   root-memcached-1             0.03%     6.762MiB / 1.889GiB   0.35%     31.6kB / 128kB    0B / 0B           10
a91be648c677   root-memcached-exporter-1    0.00%     7.125MiB / 1.889GiB   0.37%     126kB / 75.2kB    0B / 0B           5
4f755dee256b   root-minio-1                 3.99%     163.3MiB / 1.889GiB   8.44%     367kB / 889kB     1.77MB / 557kB    12
fab3799e6a97   root-grafana-1               7.37%     72.63MiB / 1.889GiB   3.76%     666kB / 790kB     1.01MB / 34.2MB   9
d16d6664924c   root-load-rules-to-mimir-1   0.00%     31.69MiB / 1.889GiB   1.64%     54.7kB / 117kB    44.9MB / 4.1kB    1
72262bb29bd1   root-github-exporter-1       0.00%     9.906MiB / 1.889GiB   0.51%     141kB / 41.4kB    3.4MB / 0B        5

```
