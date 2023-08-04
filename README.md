# Provisioning Scalable Observability Workspace

<p align="center">

<a href="https://github.com/qclaogui/codelab-monitoring/actions/workflows/ci.yml">
  <img src="https://github.com/qclaogui/codelab-monitoring/actions/workflows/ci.yml/badge.svg">
</a>

</p>

## Grafana LGTMP Stack (Loki Grafana Tempo Mimir Pyroscope) 

Base on Flow mode of Grafana Agent (also called Grafana Agent Flow) is a component-based revision of Grafana Agent

## Getting Started

[Grafana Agent Configuration Generator](https://github.com/grafana/agent-configurator) a tool allows for easy configuration of Grafana Agents Flow system

### Deployment Examples

#### [Docker Compose (docker-compose/README.md)](./docker-compose)

- [Monolithic mode (单体模式)](./docker-compose/monolithic-mode)
  - [Logs [ Agent + Loki + Grafana ]](./docker-compose/monolithic-mode/logs)
  - [Traces [ Agent + Tempo + Grafana ]](./docker-compose/monolithic-mode/traces)
  - [Metrics [ Agent + Mimir + Grafana ]](./docker-compose/monolithic-mode/metrics)
  - [Profiles [ Agent + Pyroscope + Grafana ]](./docker-compose/monolithic-mode/profiles)
  - [All In One [ Agent + Loki + Tempo + Mimir + Pyroscope + Grafana ]](./docker-compose/monolithic-mode/all-in-one)

- [Read-Write mode (读写模式)](./docker-compose/read-write-mode/README.md)
  - [Logs [ Agent + (Loki Read * 2) + (Loki Write * 3) + (Loki Backend * 2) + Grafana ]](./docker-compose/read-write-mode/logs)
  - Traces
  - [Metrics [ Agent + (Mimir Read * 2) + (Mimir Write * 3) + (Mimir Backend * 2) + Grafana ]](./docker-compose/read-write-mode/metrics)
  - Profiles

- Microservices mode (微服务模式)
  - Logs
  - Traces
  - Metrics
  - Profiles

#### Kubernetes (kubernetes/README.md)

- Microservices mode (微服务模式)
  - Logs
  - Traces
  - Metrics
  - Profiles