# Monolithic mode (单体模式) - Traces

## Monolithic mode

Monolithic mode deployment runs all top-level components in a single process, forming an instance of Tempo. The monolithic mode is the simplest to deploy, `but can not horizontally scale out` by increasing the quantity of components. To enable this mode, `-target=all` is used, which is the default.

```mermaid
flowchart LR
    Agent   --->|writes| Distributor    -->|writes| Ingester -->|writes| ObjectStorage
    Grafana -.->|reads | QueryFrontend -.->|reads | Querier -.->|reads | ObjectStorage

    subgraph Minio
        ObjectStorage{"Object Storage"}
    end

    subgraph GrafanaAgent["Grafana Agent"]
        Agent
    end

    subgraph GFGraph["Grafana"]
        Grafana
    end

    subgraph Tempo["tempo -target=all"]
        Distributor
        Querier -.->|reads| Ingester
        QueryFrontend

        Compactor --> |writes| ObjectStorage
        Compactor -.->|reads | ObjectStorage

        Optional("(optional) components ...")
    end
```
## Scaling monolithic mode

Monolithic mode can be horizontally scaled out. This scalable monolithic mode is similar to the monolithic mode in that all components are run within one process. Horizontal scale out is achieved by instantiating more than one process, with each having `-target` set to `scalable-single-binary`.

This mode offers some flexibility of scaling without the configuration complexity of the full microservices deployment.

Each of the queriers perform a DNS lookup for the frontend_address and connect to the addresses found within the DNS record.

```mermaid
flowchart LR
    Agent   --->|writes| Distributor   -->|writes| Ingester   -->|writes| ObjectStorage
    Agent   --->|writes| Distributor-2 -->|writes| Ingester-2 -->|writes| ObjectStorage
    Agent   --->|writes| Distributor-N -->|writes| Ingester-N -->|writes| ObjectStorage

    Grafana -.->|reads| QueryFrontend   -.->|reads| Querier   -.->|reads| ObjectStorage
    Grafana -.->|reads| QueryFrontend-2 -.->|reads| Querier-2 -.->|reads| ObjectStorage
    Grafana -.->|reads| QueryFrontend-N -.->|reads| Querier-N -.->|reads| ObjectStorage

    subgraph Minio
        ObjectStorage{"Object Storage"}
    end

    subgraph GrafanaAgent["Grafana Agent"]
        Agent
    end

    subgraph GFGraph["Grafana"]
        Grafana
    end

    subgraph Tempo["tempo -target=scalable-single-binary"]
        Distributor
        Querier -.->|reads| Ingester
        QueryFrontend

        Compactor --> |writes| ObjectStorage
        Compactor -.->|reads | ObjectStorage
    end


    subgraph Tempo2["tempo-2 -target=scalable-single-binary"]
        Distributor-2
        Querier-2 -.->|reads| Ingester-2
        QueryFrontend-2

        Compactor-2 --> |writes| ObjectStorage
        Compactor-2 -.->|reads | ObjectStorage
    end

    subgraph TempoN["tempo-n -target=scalable-single-binary"]
        Distributor-N
        Querier-N -.->|reads| Ingester-N
        QueryFrontend-N

        Compactor-N --> |writes| ObjectStorage
        Compactor-N -.->|reads | ObjectStorage
    end
```
