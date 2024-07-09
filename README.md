# Provisioning Scalable Observability Workspace

![CI](https://github.com/qclaogui/codelab-monitoring/actions/workflows/ci.yml/badge.svg)
![Go version](https://img.shields.io/github/go-mod/go-version/qclaogui/codelab-monitoring)
![License](https://img.shields.io/github/license/qclaogui/codelab-monitoring.svg)
![GitHub Last Commit](https://img.shields.io/github/last-commit/qclaogui/codelab-monitoring)

A simple command to run Grafana LGTMP Stack in Docker or Kubernetes.

> **NOTE**:
> This project is not intended for production use and is maintained on a best-effort basis.

## Usage

An simple use case `compose.yaml` like so:

```yaml
include: # include is available in Docker Compose version 2.20 and later, and Docker Desktop version 4.22 and later.
- path: https://github.com/qclaogui/codelab-monitoring.git#main:docker-compose/monolithic-mode/logs/compose.yaml

services:
  github-exporter:
    labels: # https://github.com/qclaogui/codelab-monitoring/blob/main/alloy-modules/compose/README.md
      metrics.grafana.com/scrape: true
    image: githubexporter/github-exporter:1.1.0
    environment:
    - REPOS=qclaogui/codelab-monitoring
```

```shell
COMPOSE_EXPERIMENTAL_GIT_REMOTE=true docker compose up -d --remove-orphans
```

Once all containers are up and running you can search for metrics in Grafana. Navigate to [http://localhost:3000](http://localhost:3000)

> In this case you can find `github-exporter` metrics and logs.

More usage examples, See: [examples/](./examples/)

---

<details>

<summary>

```shell
❯ make help
Usage:
  make <target>

Docker compose
  up-monolithic-mode-metrics                Run monolithic-mode Mimir for metrics
  up-monolithic-mode-logs                   Run monolithic-mode Loki for logs
  up-monolithic-mode-traces                 Run monolithic-mode Tempo for traces
  up-monolithic-mode-profiles               Run monolithic-mode Pyroscope for profiles
  up-monolithic-mode-all-in-one             Run monolithic-mode all-in-one
  up-read-write-mode-metrics                Run read-write-mode Mimir for metrics
```

</summary>

```shell
  up-read-write-mode-logs                   Run read-write-mode Loki for logs
  up-microservices-mode-metrics             Run microservices-mode Mimir for metrics
  up-microservices-mode-logs                Run microservices-mode Loki for logs
  up-microservices-mode-traces              Run microservices-mode Tempo for traces
  up-microservices-mode-profiles            Run microservices-mode Pyroscope for profiles
Kubernetes
  cluster                                   Create k3s cluster
  clean                                     Clean cluster
  manifests                                 Generates k8s manifests
  deploy-kube-prometheus-stack              Deploy kube-prometheus-stack manifests
  deploy-monolithic-mode-metrics            Deploy monolithic-mode Mimir for metrics
  deploy-monolithic-mode-logs               Deploy monolithic-mode Loki for logs
  deploy-monolithic-mode-profiles           Deploy monolithic-mode Pyroscope for profiles
  deploy-monolithic-mode-traces             Deploy monolithic-mode Tempo for traces
  deploy-monolithic-mode-all-in-one         Deploy monolithic-mode all-in-one
  deploy-read-write-mode-metrics            Deploy read-write-mode Mimir for metrics
  deploy-read-write-mode-logs               Deploy read-write-mode Loki for logs
  deploy-microservices-mode-logs            Deploy microservices-mode Loki for logs
  deploy-microservices-mode-metrics         Deploy microservices-mode Mimir for metrics
  deploy-microservices-mode-profiles        Deploy microservices-mode Pyroscope for profiles
  deploy-microservices-mode-traces          Deploy microservices-mode Tempo for traces

Build
  generate                                  generate embed deps
  build                                     Build binary for current OS and place it at ./bin/lgtmp_$(GOOS)_$(GOARCH)
  build-all                                 Build binaries for Linux and Mac and place them in dist/

General
  console-token                             Prints the minio-operator console jwt token
  help                                      Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/
```

</details>

## Docker Compose

The easiest way to run project locally is to use docker compose, these instructions will get you through the deploying samples with Docker Compose.

***Prerequisites:*** Make sure that you have Docker and Docker Compose installed

> **NOTE**:
> `include` is available in Docker Compose version 2.20 and later, and Docker Desktop version 4.22 and later.

### [Monolithic mode (单体模式)](./docker-compose/monolithic-mode)

- [Logs [Loki]](./docker-compose/monolithic-mode/logs)
- [Traces [Tempo]](./docker-compose/monolithic-mode/traces)
- [Metrics [Mimir]](./docker-compose/monolithic-mode/metrics)
- [Profiles [Pyroscope]](./docker-compose/monolithic-mode/profiles)
- [All In One [Loki + Tempo + Mimir + Pyroscope]](./docker-compose/monolithic-mode/all-in-one)

### [Read-Write mode (读写模式)](./docker-compose/read-write-mode)

- [Logs [Loki (Read + Write + Backend)]](./docker-compose/read-write-mode/logs)
- Traces
- [Metrics [Mimir (Read + Write + Backend)]](./docker-compose/read-write-mode/metrics)
- Profiles

### [Microservices mode (微服务模式)](./docker-compose/microservices-mode)

- [Logs [Loki (Query-Frontend + Querier + Ruler + Distributor + Ingester)]](./docker-compose/microservices-mode/logs)
- [Traces [Tempo (Query-Frontend + Querier + Distributor + Ingester + Compactor)]](./docker-compose/microservices-mode/traces)
- [Metrics [Mimir (Query-Frontend + Querier + Store-Gateway + Distributor + Ingester + Compactor)]](./docker-compose/microservices-mode/metrics)
- [Profiles [Pyroscope (Query-Frontend + Query-Scheduler + Querier + Store-Gateway + Distributor + Ingester + Compactor)]](./docker-compose/microservices-mode/profiles)

### Quick Start(docker-compose)

```shell
git clone https://github.com/qclaogui/codelab-monitoring.git && cd "$(basename "$_" .git)"

make up-monolithic-mode-all-in-one
```

Once all containers are up and running you can search for metrics in Grafana.

Navigate to [http://localhost:3000/explore](http://localhost:3000/explore) and select the search tab.

---

## Kubernetes

This project uses [bingo](https://github.com/bwplotka/bingo) (located in [.bingo/](.bingo/)), a tool to automate the versioning of Go packages.

[k3d](https://github.com/k3d-io/k3d) makes it very easy to create single- and multi-node [k3s](https://github.com/rancher/k3s) clusters in docker, e.g. for local development on Kubernetes.

### [Monolithic mode (单体模式)](./kubernetes/monolithic-mode)

- [Logs [Loki]](./kubernetes/monolithic-mode/logs)
- [Traces [Tempo]](./kubernetes/monolithic-mode/traces)
- [Metrics [Mimir]](./kubernetes/monolithic-mode/metrics)
- [Profiles [Pyroscope]](./kubernetes/monolithic-mode/profiles)
- [All In One [Loki + Tempo + Mimir + Pyroscope]](./kubernetes/monolithic-mode/all-in-one)

### [Read-Write mode (读写模式)](./kubernetes/read-write-mode)

- [Logs [Loki (Read + Write + Backend)]](./kubernetes/read-write-mode/logs)
- Traces
- [Metrics [Mimir (Read + Write + Backend)]](./kubernetes/read-write-mode/metrics)
- Profiles

### [Microservices mode (微服务模式)](./kubernetes/microservices-mode)

- [Logs [Loki (Query-Frontend + Querier + Ruler + Distributor + Ingester)]](./kubernetes/microservices-mode/logs)
- [Traces [Tempo (Query-Frontend + Querier + Distributor + Ingester + Compactor)]](./kubernetes/microservices-mode/traces)
- [Metrics [Mimir (Query-Frontend + Querier + Store-Gateway + Distributor + Ingester + Compactor)]](./kubernetes/microservices-mode/metrics)
- [Profiles [Pyroscope (Query-Frontend + Query-Scheduler + Querier + Store-Gateway + Distributor + Ingester + Compactor)]](./kubernetes/microservices-mode/profiles)

### Quick Start(kubernetes)

Install dependencies tools

```shell
git clone https://github.com/qclaogui/codelab-monitoring.git && cd "$(basename "$_" .git)"

make install-build-deps
```

Create a cluster and mapping the ingress port 80 to localhost:8080

```shell
make cluster
```

Deploy manifests

```shell
make deploy-monolithic-mode-logs
```

Once all containers are up and running you can search for logs in Grafana.

Navigate to [http://localhost:8080/explore](http://localhost:8080/explore) and select the search tab.

---

## Command line

> Take Grafana LGTMP Stack to the command line([#32](https://github.com/qclaogui/codelab-monitoring/pull/32))

```shell
❯ lgtmp --help
Grafana LGTMP Stack from the command line
L -> Loki       Like Prometheus, but for logs
G -> Grafana    The open and composable observability and data visualization platform
T -> Tempo      A high volume, minimal dependency distributed tracing backend
M -> Mimir      The most scalable Prometheus backend
P -> Pyroscope  Continuous Profiling Platform. Debug performance issues down to a single line of code

Usage:
  lgtmp [command]

Examples:
$ lgtmp up metrics


Available Commands:
  completion  Generate the autocompletion script for the specified shell
  delete      Clean up Grafana LGTMP stack from Kubernetes
  deploy      Provisioning Grafana LGTMP stack by Kubernetes
  down        Clean up Grafana LGTMP stack from Docker Compose
  help        Help about any command
  up          Provisioning Grafana LGTMP stack by Docker Compose
  version     Output the version of lgtmp

Flags:
  -h, --help   Show help for command

Use "lgtmp [command] --help" for more information about a command.
```

## Grafana LGTMP Stack default port-mapping

| Port-mapping | Component | Description |
| --- | --- | --- |
| `12345:12345`, `4317`, `4318`, `6831` | [Alloy][1] | Expose `12345` port so we can directly access `alloy` inside container |
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

## Helpful Links

- <https://grafana.com/docs/alloy/latest/>
- <https://github.com/grafana/alloy-modules>
- <https://github.com/docker/compose>
- <https://github.com/k3d-io/k3d>
- <https://github.com/k3s-io/k3s>
- [Grafana Agent Configuration Generator](https://github.com/grafana/agent-configurator) a tool allows for easy configuration of Grafana Agents Flow system
