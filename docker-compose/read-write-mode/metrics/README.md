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
    Agent   --> |writes| Nginx --> |writes| Distributor   --> |writes| Ingester -->|writes| ObjectStorage
    Grafana -.->|reads | Nginx -.->|reads | QueryFrontend -.->|reads | Querier -.->|reads | StoreGateway -.->|reads| ObjectStorage

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

    subgraph MimirWrite["mimir -target=write"]
        Ingester
        Distributor
    end

    subgraph MimirBackend["mimir -target=backend"]
        StoreGateway
        Compactor --> |writes| ObjectStorage
        Compactor -.->|reads | ObjectStorage

        Optional["`(optional) components ...`"]
    end

    subgraph MimirRead["mimir -target=read"]
        Querier -.->|reads| Ingester
        QueryFrontend
    end
```

## Getting Started

Simply run `docker compose up` and all the components will start.
