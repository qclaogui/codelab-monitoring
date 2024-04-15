# Monolithic mode (单体模式) - Traces

## Monolithic mode

Monolithic mode deployment runs all top-level components in a single process, forming an instance of Tempo. The monolithic mode is the simplest to deploy, `but can not horizontally scale out` by increasing the quantity of components. To enable this mode, `-target=all` is used, which is the default.

```mermaid
flowchart LR
    A --->|writes| D  -->|writes| I -->|writes| M
    G -.->|reads | QF -.->|reads| Q -.->|reads| M

    subgraph Minio
        M{"Object Storage"}
    end
    subgraph Agent["Grafana Alloy"]
        A("alloy")
    end
    subgraph Grafana
        G("grafana")
    end

    subgraph Tempo["tempo -target=all"]
        D("distributor")
        I("ingester")

        Q("querier") -.->|reads| I

        QF("query-frontend")
        C("compactor")

        C  -->|writes| M
        C -.->|reads | M
    end
```
## Scaling monolithic mode

Monolithic mode can be horizontally scaled out. This scalable monolithic mode is similar to the monolithic mode in that all components are run within one process. Horizontal scale out is achieved by instantiating more than one process, with each having `-target` set to `scalable-single-binary`.

This mode offers some flexibility of scaling without the configuration complexity of the full microservices deployment.

Each of the queriers perform a DNS lookup for the frontend_address and connect to the addresses found within the DNS record.

```mermaid
flowchart LR
    A -->|writes| Tempo  -->|writes| M
    A -->|writes| Tempo2 -->|writes| M
    A -->|writes| TempoN -->|writes| M

    G -.->|reads| Tempo  -.->|reads| M
    G -.->|reads| Tempo2 -.->|reads| M
    G -.->|reads| TempoN -.->|reads| M

    subgraph Minio
        M{"Object Storage"}
    end
    subgraph Agent["Grafana Alloy"]
        A("alloy")
    end
    subgraph Grafana
        G("grafana")
    end

    subgraph Tempo["tempo -target=scalable-single-binary"]
        CP["Tempo Components ..."]
    end
    subgraph Tempo2["tempo-2 -target=scalable-single-binary"]
        CP-2["Tempo Components ..."]
    end
    subgraph TempoN["tempo-n -target=scalable-single-binary"]
        CP-N["`Tempo Components ...`"]
    end
```

## Quick Start

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
make deploy-monolithic-mode-traces
```

Once all containers are up and running you can search for traces in Grafana.

Navigate to [http://localhost:8080/explore](http://localhost:8080/explore) and select the search tab.

## Clean up

```shell
make delete-monolithic-mode-traces
```
