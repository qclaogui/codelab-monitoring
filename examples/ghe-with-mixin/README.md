# Prometheus GitHub Exporter

Exposes basic metrics for your repositories from the GitHub API, to a Prometheus compatible endpoint.

## Docker compose

```yaml
include:
- path: https://github.com/qclaogui/codelab-monitoring.git#main:docker-compose/monolithic-mode/logs/compose.yaml

services:
  github-exporter:
    image: githubexporter/github-exporter:1.1.0
    environment:
    - REPOS=qclaogui/codelab-monitoring

```

## Try it

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
```

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose down
```

Once all containers are up and running you can search for metrics(from Mimir) logs(from Loki) traces(from Tempo) and profiles(Pyroscope) in Grafana.

> In this case you can find `github-exporter` metrics and logs.

Navigate to [http://localhost:3000](http://localhost:3000)

## Debug info(`grafana-agent` target scrape)

<http://localhost:12345/component/module.file.metrics_primary/module.file.mf_label_auto_scrape/prometheus.scrape.pc_docker_metrics>

## Resource Utilization

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose stats
```

```shell
CONTAINER ID   NAME                         CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O         PIDS
613d8d5e7e30   root-grafana-agent-1         2.72%     180.7MiB / 1.889GiB   9.34%     1.46MB / 4.61MB   3.15MB / 1.56MB   11
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
