# Microservices mode (微服务模式) - Profiles

In microservices mode, components are deployed in distinct processes.

[Pyroscope (Query-Frontend + Query-Scheduler + Querier + Distributor + Ingester)]

## Diagram

The below diagram describes how data flows.

```mermaid
flowchart LR
    A ---->|writes| D   -->|writes| I   -->|writes| M
    G -.-> |reads | QF -.->|reads | QS -.->|reads | Q -.->|reads | SG -.->|reads| M

    subgraph Minio
        M{"Object Storage"}
    end

    subgraph Agent["Grafana Alloy"]
        A("alloy")
    end
    subgraph Grafana
        G("grafana")
    end

    subgraph Ingester["pyroscope -target=ingester"]
        I("ingester")
    end

    subgraph Distributor["pyroscope -target=distributor"]
        D("distributor")
    end

    subgraph QueryScheduler["pyroscope -target=query-scheduler"]
        QS("query-scheduler")
    end

    subgraph QueryFrontend["pyroscope -target=query-frontend"]
        QF("query-frontend")
    end

    subgraph StoreGateway["pyroscope -target=store-gateway"]
        SG("store-gateway")
    end

    subgraph Querier["pyroscope -target=querier"]
        Q("querier") -.->|reads| I
        %% Q -.->|coming soon | M
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
make deploy-microservices-mode-profiles
```

Once all containers are up and running you can search for profiles in Grafana.

Navigate to [http://localhost:8080/explore](http://localhost:8080/explore) and select the search tab.

## Clean up

```shell
make delete-microservices-mode-profiles
```
