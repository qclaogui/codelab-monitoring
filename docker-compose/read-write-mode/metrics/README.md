# Read-Write mode (读写模式) - Metrics

The read-write mode provides an alternative to monolithic and microservices modes.

In read-write mode, components are grouped into three services to ease the operational overhead whilst still allowing scale to be tuned separately on the read and write paths. The services group the components as follows:

- read
  - query-frontend
  - querier
- backend
  - store-gateway
  - compactor
  - (optional) ruler
  - (optional) alertmanager
  - (optional) query-scheduler
  - (optional) overrides-exporter
- write
  - distributor
  - ingester

Similar to the other modes, each Grafana Mimir process is invoked with its `-target` parameter set to the specific service: `-target=read`, `-target=write`, or `-target=backend`.

## Diagram

The below diagram describes the various components of this deployment, and how data flows between them.

```mermaid
flowchart LR
    Agent["Grafana Agent"] --> | writes | GateWay["Load Balancer(Nginx)"]
    Grafana                -.-> | reads | GateWay

    GateWay -->  | writes| Distributor
    GateWay -.-> | reads | QueryFrontend

    subgraph MimirWrite["mimir -target=write"]
        Distributor["distributor"] --> | writes | Ingester["ingester"]
    end

    subgraph MimirRead["mimir -target=read"]
        QueryFrontend["query-frontend"] -.-> | reads | Querier["querier"]
    end

    subgraph MimirBackend["mimir -target=backend"]
        StoreGateway["store-gateway"]
        Compactor["compactor"]

        Optional["`(optional) components ...`"]
    end

    subgraph Minio
        ObjectStorage["Object Storage"]
    end

    Ingester & Compactor --> | writes | ObjectStorage

    Querier                  -.-> | reads | Ingester & StoreGateway
    Compactor & StoreGateway -.-> | reads | ObjectStorage
    
```

## Getting Started

Simply run `docker-compose up` and all the components will start.
