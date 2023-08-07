# Monolithic mode (单体模式) - Logs

## Monolithic mode

The simplest mode of operation sets `-target=all`. This is the default target, and it does not need to be specified. This is monolithic mode; it runs all of Loki’s microservice components inside a single process as a single binary or Docker image.

```mermaid
flowchart LR
    Agent   --> |writes| Distributor   --> Ingester --> |writes| ObjectStorage
    Grafana -.->|reads | QueryFrontend -.-> Querier -.->|reads | ObjectStorage

    subgraph Minio
        ObjectStorage{"Object Storage"}
    end

    subgraph GrafanaAgent["Grafana Agent"]
        Agent
    end

    subgraph GFGraph["Grafana"]
        Grafana
    end

    subgraph Loki["loki -target=all"]
        Ingester
        Distributor
        Ruler
        Querier
        QueryFrontend
    end
```

## Scaling monolithic mode

Horizontally scale up a monolithic mode deployment to more instances by using a shared object store, and by configuring the ring section to share state between all instances.

High availability can be configured by running two Loki instances using memberlist_config configuration and a shared object store.

```mermaid
flowchart LR
    Agent   -->|writes| Distributor   --> Ingester   -->|writes| ObjectStorage
    Agent   -->|writes| Distributor-2 --> Ingester-2 -->|writes| ObjectStorage
    Agent   -->|writes| Distributor-N --> Ingester-N -->|writes| ObjectStorage
    
    Grafana -.->|reads| QueryFrontend   -.-> Querier   -.->|reads| ObjectStorage
    Grafana -.->|reads| QueryFrontend-2 -.-> Querier-2 -.->|reads| ObjectStorage
    Grafana -.->|reads| QueryFrontend-N -.-> Querier-N -.->|reads| ObjectStorage

    subgraph Minio
        ObjectStorage{"Object Storage"}
    end

    subgraph GrafanaAgent["Grafana Agent"]
        Agent
    end

    subgraph GFGraph["Grafana"]
        Grafana
    end

    subgraph Loki["loki -target=all"]
        Ingester
        Distributor
        Ruler
        Querier
        QueryFrontend
    end

    subgraph Loki2["loki-2 -target=all"]
        Ingester-2
        Distributor-2
        Ruler-2
        Querier-2
        QueryFrontend-2
    end

    subgraph LokiN["loki-N -target=all"]
        Ingester-N
        Distributor-N
        Ruler-N
        Querier-N
        QueryFrontend-N
    end
```
