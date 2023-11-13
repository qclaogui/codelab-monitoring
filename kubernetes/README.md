# Kubernetes

## Usage

``` shell
make help

Usage:
  make <target>

Dependencies
  install-build-deps                        Install dependencies tools

Dashboards
  dashboards_out                            Copy app's dashboards to grafana dashboards provision path

Lint & fmt
  check                                     Check all the mixin files
  copyright                                 Add Copyright header to .go files.

Kubernetes
  cluster                                   Create k3s cluster
  clean                                     Clean cluster
  manifests                                 Generates k8s manifests
  monolithic-mode-manifests                 Generates monolithic-mode manifests
  microservices-mode-manifests              Generates microservices-mode manifests
  logs-monolithic-mode-deploy               Deploy monolithic-mode logs
  logs-monolithic-mode-clean                Clean monolithic-mode logs manifests
  metrics-microservices-mode-deploy         Deploy microservices-mode metrics

General
  help                                      Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/

```

## Create k3s cluster

``` shell
make k3s
```

## Deploy manifests

```shell
make logs-monolithic-mode-deploy
```

## Open browser

[http://grafana.localhost:8080/explore](http://grafana.localhost:8080/explore)

## Clean manifests

```shell
make logs-monolithic-mode-clean
```
