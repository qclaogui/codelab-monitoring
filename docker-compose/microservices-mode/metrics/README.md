# Microservices mode (微服务模式) - Metrics

In microservices mode, components are deployed in distinct processes. Scaling is per component, which allows for greater flexibility in scaling and more granular failure domains. Microservices mode is the preferred method for a production deployment, but it is also the most complex.

In microservices mode, each Grafana Mimir process is invoked with its -target parameter set to a specific Grafana Mimir component (for example, `-target=ingester` or `-target=distributor`). To get a working Grafana Mimir instance, you must deploy every required component.

## Grafana Mimir components

Grafana Mimir includes a set of [components](https://grafana.com/docs/mimir/latest/references/architecture/components/) that interact to form a cluster.

- Compactor
- Distributor
- Ingester
- Querier
- Query-frontend
- Store-gateway
- (Optional) Alertmanager
- (Optional) Overrides-exporter
- (Optional) Query-scheduler
- [(Optional) Ruler](https://grafana.com/docs/mimir/latest/references/architecture/components/ruler)
  - [ruler `internal mode` (default mode)](https://grafana.com/docs/mimir/latest/references/architecture/components/ruler/#internal)
  - [ruler `remote mode`](https://grafana.com/docs/mimir/latest/references/architecture/components/ruler/#remote)

## Diagram

The below diagram describes how data flows.

```mermaid
flowchart LR
    A  -->|writes| GW  -->|writes| D  --->|writes| I  -->|writes| M
    G -.->|reads | GW -.->|reads | QF -.->|reads | QS -.->|reads | Q -.->|reads | SG -.->|reads| M

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

    subgraph Ingester["mimir -target=ingester"]
        I("ingester")
    end
    subgraph Distributor["mimir -target=distributor"]
        D("distributor")
    end
    subgraph StoreGateway["mimir -target=store-gateway"]
        SG("store-gateway")
    end
    subgraph Querier["mimir -target=querier"]
        Q("querier") -.->|reads| I
    end
    subgraph QueryScheduler["mimir -target=query-scheduler"]
        QS("(optional) query-scheduler")
    end
    subgraph QueryFrontend["mimir -target=query-frontend"]
        QF("query-frontend")
    end
    subgraph Compactor["mimir -target=compactor"]
        C("compactor")

        C  -->|writes| M
        C -.->|reads | M
    end

    subgraph Alertmanager["mimir -target=alertmanager"]
        AM("(optional) alertmanager") --> M
    end

    %% ruler in Remote mode
    subgraph Ruler["mimir -target=ruler"]
        R("(optional) ruler")

        R --> QF & I & AM & M
    end
```
