
<p align="center">
  <h1>Provisioning Scale Observability Workspace</h1>
</p>

<p align="center">

<a href="https://github.com/qclaogui/codelab-monitoring/actions/workflows/ci.yml">
  <img src="https://github.com/qclaogui/codelab-monitoring/actions/workflows/ci.yml/badge.svg">
</a>

</p>

## Grafana LGTM Stack (Loki Grafana Tempo Mimir) 

Base on Flow mode of Grafana Agent (also called Grafana Agent Flow) is a component-based revision of Grafana Agent

## Getting Started

### Deployment Examples

#### [Docker Compose (docker-compose/README.md)](docker-compose/README.md)

- [Monolithic mode (单体模式)](./docker-compose/monolithic-mode/README.md)
  - [All in one (Grafana Agent + Loki + Tempo + Mimir + Pyroscope + Grafana)](./docker-compose/monolithic-mode/all-in-one/docker-compose.yaml)
  - [Metrics (Grafana Agent + Mimir + Grafana)](./docker-compose/monolithic-mode/metrics/docker-compose.yaml)
  - [Logs (Grafana Agent + Loki + Grafana)](./docker-compose/monolithic-mode/logs/docker-compose.yaml)
  - [Traces (Grafana Agent + Tempo + Grafana) //TODO(qc)](TODO)
  - [Profiles (Grafana Agent + Pyroscope + Grafana) //TODO(qc)](TODO)
- [Read-Write mode (读写模式)](./docker-compose/read-write-mode/README.md)
  - TODO(qc)
- [Microservices mode (微服务模式)](./docker-compose/microservices-mode/README.md)
  - TODO(qc)

#### [Kubernetes (kubernetes/README.md)](kubernetes/README.md)

- [Microservices mode](./docker-compose/microservices-mode/README.md)
  - TODO(qc)