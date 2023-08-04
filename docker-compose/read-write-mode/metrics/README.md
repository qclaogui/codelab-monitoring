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
%%{init: {"flowchart": {"htmlLabels": false}} }%%
flowchart LR
    Agent["Grafana Agent"] --> | writes | Nginx
    Grafana -.-> | reads | Nginx

    Nginx --> | writes| Distributor["distributor"]
    Nginx -.-> | reads | QueryFrontend["query-frontend"]

    subgraph MimirWrite["mimir -target=write"]
        Distributor --> | writes  | Ingester["ingester"]
    end

    subgraph MimirRead["mimir -target=read"]
        QueryFrontend -.-> | reads  | Querier["querier"]
    end

    subgraph MimirBackend["mimir -target=backend"]
        StoreGateway["store-gateway"]
        Compactor["compactor"]

        Ruler["(optional) ruler"]
        Alertmanager["(optional) alertmanager"]
        QueryScheduler["(optional) query-scheduler"]
        OverridesExporter["(optional) overrides-exporter"]
    end

    subgraph Minio
        ObjectStorage["Object Storage"]
    end

    Ingester --> | writes | ObjectStorage
    Compactor --> | writes| ObjectStorage

    Querier  -.-> | reads | Ingester
    Querier  -.-> | reads | StoreGateway
    Compactor -.-> | reads| ObjectStorage
    StoreGateway -.-> | reads | ObjectStorage
    
```

<!-- ![Alt text](https://grafana.com/docs/mimir/latest/references/architecture/deployment-modes/read-write-mode.svg) -->

## Getting Started

Simply run `docker-compose up` and all the components will start.
