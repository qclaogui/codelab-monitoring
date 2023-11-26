# Monolithic mode (单体模式) - Metrics

## Monolithic mode

The monolithic mode runs all required components in a single process and is the default mode of operation, which you can set by specifying `-target=all`.

Monolithic mode is the simplest way to deploy Grafana Mimir and is useful if you want to get started quickly or want to work with Grafana Mimir in a development environment.

```mermaid
flowchart LR
    A -->|writes| GW --->|writes| D  --> |writes| I --> |writes| M
    G -.->|reads | GW -.->|reads | QF -.->|reads | Q -.->|reads | SG -.->|reads| M

    subgraph Minio
        M{"Object Storage"}
    end
    subgraph Agent["Grafana Agent"]
        A("agent")
    end
    subgraph Grafana
        G("grafana")
    end
    subgraph Gateway["Load Balancer"]
        GW{"Nginx"}
    end

    subgraph Mimir["mimir -target=all"]
        I("ingester")
        D("distributor")
        SG("store-gateway")
        QF("query-frontend")

        Q("querier")  -.->|reads | I 
        C("compactor") -->|writes| M

        C -.->|reads | M
    end
```

## Scaling monolithic mode

Monolithic mode can be horizontally scaled out by deploying multiple Grafana Mimir binaries with `-target=all`. This approach provides high-availability and increased scale without the configuration complexity of the full microservices deployment.

```mermaid
flowchart LR
    A  -->|writes| GW     -->|writes| Mimir -->|writes| M
    GW -->|writes| Mimir2 -->|writes| M
    GW -->|writes| MimirN -->|writes| M
    
    G  -.->|reads| GW     -.->|reads| Mimir -.->|reads| M    
    GW -.->|reads| Mimir2 -.->|reads| M
    GW -.->|reads| MimirN -.->|reads| M

    subgraph Minio
        M{"Object Storage"}
    end
    subgraph Agent["Grafana Agent"]
        A("agent")
    end
    subgraph Grafana
        G("grafana")
    end

    subgraph Gateway["Load Balancer"]
        GW{"Nginx"}
    end

    subgraph Mimir["mimir -target=all"]
        CP["Mimir Components ..."]
    end
    subgraph Mimir2["mimir-2 -target=all"]
        CP-2["Mimir Components ..."]
    end
    subgraph MimirN["mimir-n -target=all"]
        CP-N["Mimir Components ..."]
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
make deploy-monolithic-mode-metrics
```

Once all containers are up and running you can search for traces in Grafana.

Navigate to [http://localhost:8080/explore](http://localhost:8080/explore) and select the search tab.

## Clean up

```shell
make delete-monolithic-mode-metrics
```
