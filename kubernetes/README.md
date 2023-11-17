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
  manifests-monolithic-mode                 Generates monolithic-mode manifests
  manifests-microservices-mode              Generates microservices-mode manifests
  deploy-prometheus-operator-crds           Deploy prometheus-operator-crds manifests
  deploy-kube-prometheus-stack              Deploy kube-prometheus-stack manifests
  clean-kube-prometheus-stack               Clean kube-prometheus-stack manifests
  deploy-grafana                            Deploy grafana manifests
  deploy-monolithic-mode-logs               Deploy monolithic-mode logs
  deploy-monolithic-mode-profiles           Deploy monolithic-mode profiles
  deploy-microservices-mode-metrics         Deploy microservices-mode metrics

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
make clean-monolithic-mode-logs
```
