# Microservices mode (微服务模式) - Profiles

In microservices mode, components are deployed in distinct processes.

[Pyroscope (Query-Frontend + Query-Scheduler + Querier + Distributor + Ingester)]

## Diagram

The below diagram describes how data flows.

```mermaid
flowchart LR
    A ---->|writes| D   -->|writes| I   -->|writes| M
    G -.-> |reads | QF -.->|reads | QS -.->|reads | Q

    subgraph Minio
        M{"Object Storage"}
    end

    subgraph Agent["Grafana Agent"]
        A("agent")
    end
    subgraph Grafana
        G("grafana")
    end

    subgraph Ingester["pyroscope -target=ingester"]
        I("ingester")
    end

    subgraph Distributor["pyroscope -target=distributor"]
        D("distributor")
    end

    subgraph QueryScheduler["pyroscope -target=query-scheduler"]
        QS("query-scheduler")
    end

    subgraph QueryFrontend["pyroscope -target=query-frontend"]
        QF("query-frontend")
    end

    subgraph Querier["pyroscope -target=querier"]
        Q("querier") -.->|reads| I
        %% Q -.->|coming soon | M
    end

```

Once all containers are up and running you can search for traces in Grafana.
Navigate to [http://localhost:3000/explore](http://localhost:3000/explore) and select the search tab.
