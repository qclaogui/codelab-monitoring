# Monolithic mode (单体模式) - Profiles

## Monolithic mode

The monolithic mode runs all required components in a single process and is the default mode of operation, which you can set by specifying `-target=all`.

```mermaid
flowchart LR
    A -->|writes| D -->|writes| I -->|writes| M
    G -.->|reads| Q -.->|reads| I

    subgraph Minio
        M{"Object Storage"}
    end
    subgraph Agent["Grafana Agent"]
        A("agent")
    end
    subgraph Grafana
        G("grafana")
    end

    subgraph Pyroscope["pyroscope -target=all"]
        I("ingester")
        D("distributor")
        Q("querier")
    end
```
