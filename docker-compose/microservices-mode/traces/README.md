# Monolithic mode (单体模式) - Traces

The monolithic mode runs all required components in a single process.

## Diagram

The below diagram describes how data flows.

```mermaid
flowchart LR
    A --->|writes| D   -->|writes| I  -->|writes| M
    G -.->|reads | QF -.->|reads | Q -.->|reads | M

    subgraph Minio
        M{"Object Storage"}
    end
    subgraph Agent["Grafana Agent"]
        A("agent")
    end
    subgraph Grafana
        G("grafana")
    end

    subgraph Ingester[" -target=ingester"]
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