# Monolithic mode (单体模式) - Traces

The monolithic mode runs all required components in a single process.

## Diagram

The below diagram describes how data flows.

```mermaid
flowchart LR
    Agent   --->|writes| Distributor -->   |writes| Ingester -->|writes| ObjectStorage
    Grafana -.->|reads | QueryFrontend -.->|reads | Querier -.->|reads | ObjectStorage

    subgraph Minio
        ObjectStorage{"Object Storage"}
    end

    subgraph GrafanaAgent["Grafana Agent"]
        Agent
    end

    subgraph GFGraph["Grafana"]
        Grafana
    end

    subgraph TempoIngester["tempo -target=ingester"]
        Ingester
    end

    subgraph TempoDistributor["tempo -target=distributor"]
        Distributor
    end

    subgraph TempoQuerier["tempo -target=querier"]
        Querier -.->|reads| Ingester
    end

    subgraph TempoQueryFrontend["tempo -target=query-frontend"]
        QueryFrontend
    end

    subgraph TempoCompactor["tempo -target=compactor"]
        Compactor --> |writes| ObjectStorage
        Compactor -.->|reads | ObjectStorage
    end
```