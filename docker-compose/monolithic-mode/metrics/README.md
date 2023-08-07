# Monolithic mode (单体模式) - Metrics

## Monolithic mode

The monolithic mode runs all required components in a single process and is the default mode of operation, which you can set by specifying `-target=all`.

Monolithic mode is the simplest way to deploy Grafana Mimir and is useful if you want to get started quickly or want to work with Grafana Mimir in a development environment.

```mermaid
flowchart LR
    Agent   --->|writes| Distributor -->   |writes| Ingester --> |writes| ObjectStorage
    Grafana -.->|reads | QueryFrontend -.->|reads | Querier  -.->|reads | StoreGateway -.->|reads| ObjectStorage

    subgraph Minio
        ObjectStorage{"Object Storage"}
    end

    subgraph GrafanaAgent["Grafana Agent"]
        Agent
    end

    subgraph GFGraph["Grafana"]
        Grafana
    end

    subgraph Mimir["mimir -target=all"]
        Ingester
        Distributor
        StoreGateway
        QueryFrontend
        Querier -.->|reads| Ingester
        
        Compactor --> |writes| ObjectStorage
        Compactor -.->|reads | ObjectStorage
        
        Optional("(optional) components ...")
    end

```
## Scaling monolithic mode

Monolithic mode can be horizontally scaled out by deploying multiple Grafana Mimir binaries with `-target=all`. This approach provides high-availability and increased scale without the configuration complexity of the full microservices deployment.

```mermaid
flowchart LR
    Agent -->|writes| Nginx -->|writes| Distributor -->|writes| Ingester -->|writes| ObjectStorage
    
    Nginx -->|writes| Distributor-2 -->|writes| Ingester-2 -->|writes| ObjectStorage
    Nginx -->|writes| Distributor-N -->|writes| Ingester-N -->|writes| ObjectStorage
    
    Grafana -.->|reads| Nginx -.->|reads| QueryFrontend -.->|reads| Querier -.->|reads| StoreGateway -.->|reads| ObjectStorage
    
    Nginx -.->|reads| QueryFrontend-2 -.->|reads| Querier-2 -.->|reads| StoreGateway-2 -.->|reads| ObjectStorage
    Nginx -.->|reads| QueryFrontend-N -.->|reads| Querier-N -.->|reads| StoreGateway-N -.->|reads| ObjectStorage

    subgraph Minio
        ObjectStorage{"Object Storage"}
    end

    subgraph GrafanaAgent["Grafana Agent"]
        Agent
    end

    subgraph GFGraph["Grafana"]
        Grafana
    end

    subgraph GateWay["Load Balancer"]
        Nginx{"Nginx"}
    end

    subgraph Mimir["mimir -target=all"]
        Ingester
        Distributor
        StoreGateway
        QueryFrontend
        Querier -.->|reads| Ingester
        
        Compactor --> |writes| ObjectStorage
        Compactor -.->|reads | ObjectStorage
    end

    subgraph Mimir2["mimir-2 -target=all"]
        Ingester-2
        Distributor-2
        StoreGateway-2
        QueryFrontend-2
        Querier-2 -.->|reads| Ingester-2
        
        Compactor-2 --> |writes| ObjectStorage
        Compactor-2 -.->|reads | ObjectStorage
    end

    subgraph MimirN["mimir-n -target=all"]
        Ingester-N
        Distributor-N
        StoreGateway-N
        QueryFrontend-N
        Querier-N -.->|reads| Ingester-N
        
        Compactor-N --> |writes| ObjectStorage
        Compactor-N -.->|reads | ObjectStorage
    end
```