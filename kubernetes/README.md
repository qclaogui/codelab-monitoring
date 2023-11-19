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

Docker compose
  up-monolithic-mode-metrics                Run monolithic-mode metrics
  up-monolithic-mode-logs                   Run monolithic-mode logs
  up-monolithic-mode-traces                 Run monolithic-mode traces
  up-monolithic-mode-profiles               Run monolithic-mode profiles
  up-monolithic-mode-all-in-one             Run monolithic-mode all-in-one
  up-read-write-mode-metrics                Run read-write-mode metrics
  up-read-write-mode-logs                   Run read-write-mode logs
  up-read-write-mode-traces                 Run read-write-mode traces
  up-read-write-mode-profiles               Run read-write-mode profiles
  up-microservices-mode-metrics             Run microservices-mode metrics
  up-microservices-mode-logs                Run microservices-mode logs
  up-microservices-mode-traces              Run microservices-mode traces
  up-microservices-mode-profiles            Run microservices-mode profiles

Kubernetes
  cluster                                   Create k3s cluster
  clean                                     Clean cluster
  manifests                                 Generates k8s manifests
  manifests-monolithic-mode                 Generates monolithic-mode manifests
  manifests-read-write-mode                 Generates read-write-mode manifests
  manifests-microservices-mode              Generates microservices-mode manifests
  deploy-prometheus-operator-crds           Deploy prometheus-operator-crds manifests
  deploy-kube-prometheus-stack              Deploy kube-prometheus-stack manifests
  deploy-grafana                            Deploy grafana manifests
  deploy-monolithic-mode-logs               Deploy monolithic-mode logs
  deploy-monolithic-mode-profiles           Deploy monolithic-mode profiles
  deploy-read-write-mode-logs               Deploy read-write-mode logs
  deploy-microservices-mode-metrics         Deploy microservices-mode metrics
  deploy-microservices-mode-profiles        Deploy microservices-mode profiles

General
  help                                      Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/

```

## Create k3s cluster

``` shell
make cluster
```

## Deploy manifests

```shell
make deploy-monolithic-mode-logs
```

## Open browser

[http://grafana.localhost:8080/explore](http://grafana.localhost:8080/explore)

## Clean manifests

```shell
make delete-monolithic-mode-logs
```
