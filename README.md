# Provisioning Scalable Observability Workspace

<p align="center">
  <a href="https://github.com/qclaogui/codelab-monitoring/actions/workflows/ci.yml">
    <img src="https://github.com/qclaogui/codelab-monitoring/actions/workflows/ci.yml/badge.svg">
  </a>
</p>

## Grafana LGTMP Stack (Loki Grafana Tempo Mimir Pyroscope)

Base on Flow mode of Grafana Agent.

[Grafana Agent Configuration Generator](https://github.com/grafana/agent-configurator) a tool allows for easy configuration of Grafana Agents Flow system

## Docker Compose

These instructions will get you through the deploying samples with Docker Compose.

***Prerequisites:*** Make sure that you have Docker and Docker Compose installed

> NOTE:
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
- [Profiles [Pyroscope (Query-Frontend + Query-Scheduler + Querier + Distributor + Ingester)]](./docker-compose/microservices-mode/profiles)

## Kubernetes

[cortex-kustomize](https://github.com/qclaogui/cortex-kustomize) provides a common `base` for Mimir deployment to Kubernetes.

### [Microservices mode (微服务模式)](./kubernetes/microservices-mode)

- Logs
- Traces
- [Metrics [Mimir (Query-Frontend + Querier + Store-Gateway + Distributor + Ingester + Compactor)]](./kubernetes/microservices-mode/metrics)
- Profiles
