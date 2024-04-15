# Microservices mode (微服务模式) - Traces

In microservices mode, components are deployed in distinct processes.

## Diagram

The below diagram describes how data flows.

```mermaid
flowchart LR
    A --->|writes| D   -->|writes| I  -->|writes| M
    G -.->|reads | QF -.->|reads | Q -.->|reads | M

    subgraph Minio
        M{"Object Storage"}
    end
    subgraph Agent["Grafana Alloy"]
        A("alloy")
    end
    subgraph Grafana
        G("grafana")
    end

    subgraph Ingester["tempo -target=ingester"]
        I("ingester")
    end

    subgraph Distributor["tempo -target=distributor"]
        D("distributor")
    end

    subgraph Querier["tempo -target=querier"]
        Q("querier") -.->|reads| I
    end

    subgraph QueryFrontend["tempo -target=query-frontend"]
        QF("query-frontend")
    end
    
    subgraph Compactor["tempo -target=compactor"]
        C("compactor")
        C  -->|writes| M
        C -.->|reads | M
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
make deploy-microservices-mode-traces
```

Once all containers are up and running you can search for traces in Grafana.

Navigate to [http://localhost:8080/explore](http://localhost:8080/explore) and select the search tab.

## Clean up

```shell
make delete-microservices-mode-traces
```
