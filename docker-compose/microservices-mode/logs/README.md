# Microservices mode (微服务模式) - Logs

The microservices deployment mode instantiates components of Loki as distinct processes. Each process is invoked specifying its target:

- ingester
- distributor
- query-frontend
- query-scheduler
- querier
- index-gateway
- ruler
- compactor

Running components as individual microservices allows scaling up by increasing the quantity of microservices.

![Loki microservices mode](https://grafana.com/docs/loki/latest/fundamentals/architecture/components/loki_architecture_components.svg)

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

    subgraph Ingester["loki -target=ingester"]
        I("ingester")
    end

    subgraph Distributor["loki -target=distributor"]
        D("distributor")
    end

    subgraph Querier["loki -target=querier"]
        Q("querier") -.->|reads| I
    end

    subgraph QueryFrontend["loki -target=query-frontend"]
        QF("query-frontend")
    end

    subgraph Ruler["loki -target=ruler"]
        R("ruler")
        R -.->|reads | M & I
    end
```
