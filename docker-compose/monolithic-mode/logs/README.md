# Monolithic mode (单体模式) - Logs

## Monolithic mode

The simplest mode of operation sets `-target=all`. This is the default target, and it does not need to be specified. This is monolithic mode; it runs all of Loki’s microservice components inside a single process as a single binary or Docker image.

```mermaid
flowchart LR
    A  -->|writes| GW --> |writes| D   -->|writes| I  -->|writes| M
    G -.->|reads | GW -.->|reads | QF -.->|reads | Q -.->|reads | M

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

    subgraph Loki["loki -target=all"]
        I("ingester")
        D("distributor")
        R("ruler")
        Q("querier")
        QF("query-frontend")
    end
```

## Scaling monolithic mode

Horizontally scale up a monolithic mode deployment to more instances by using a shared object store, and by configuring the ring section to share state between all instances.

High availability can be configured by running two Loki instances using memberlist_config configuration and a shared object store.

```mermaid
flowchart LR
    A  -->|writes| GW -->|writes| Loki -->|writes| M
    GW -->|writes| Loki2 -->|writes| M
    GW -->|writes| LokiN -->|writes| M

    G  -.->|reads| GW    -.->|reads| Loki -.->|reads| M
    GW -.->|reads| Loki2 -.->|reads| M
    GW -.->|reads| LokiN -.->|reads| M

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

    subgraph Loki["loki -target=all"]
        CP["Loki Components ..."]
    end
    subgraph Loki2["loki-2 -target=all"]
        CP-2["Loki Components ..."]
    end
    subgraph LokiN["loki-N -target=all"]
        CP-N["Loki Components ..."]
    end
```
