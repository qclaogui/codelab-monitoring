# Monolithic mode (单体模式) - Metrics

The monolithic mode runs all required components in a single process and is the default mode of operation, which you can set by specifying `-target=all`.
## Diagram

Monolithic mode is the simplest way to deploy Grafana Mimir and is useful if you want to get started quickly or want to work with Grafana Mimir in a development environment.

The below diagram describes how data flows.

```mermaid
%%{init: {"flowchart": {"htmlLabels": false}} }%%
flowchart LR
    GrafanaAgent["Grafana Agent"] ---> | writes | Distributor
    Grafana -.-> | reads | QueryFrontend["query-frontend"]

    subgraph Mimir["mimir -target=all"]
        Distributor["distributor"] --> | writes | Ingester["ingester"]

        QueryFrontend -.-> | reads  | Querier["querier"]
        Querier       -.-> | reads  | Ingester["ingester"]
        Querier       -.-> | reads  | StoreGateway["store-gateway"]
        
        Compactor["compactor"]
        
        Optional["`(optional) components ...`"]
    end

    subgraph Minio
        ObjectStorage["Object Storage"]
    end

    Ingester & Compactor     -->  | writes | ObjectStorage
    Compactor & StoreGateway -.-> | reads  | ObjectStorage

```


Monolithic mode can be horizontally scaled out by deploying multiple Grafana Mimir binaries with `-target=all`. This approach provides high-availability and increased scale without the configuration complexity of the full `microservices deployment`.

The below diagram describes how data flows.


```mermaid
flowchart LR
    GrafanaAgent["Grafana Agent"] --> | writes | GateWay["Load Balancer(Nginx)"]
    Grafana -.-> | reads | GateWay

    GateWay -->   | writes| Distributor & Distributor2 & DistributorN
    GateWay -.->  | reads | QueryFrontend & QueryFrontend2 & QueryFrontendN

    subgraph Mimir1["mimir-1 -target=all"]
        Distributor["distributor"] --> | writes| Ingester["ingester"]

        QueryFrontend["query-frontend"] -.-> | reads | Querier["querier"]

        Querier["querier"] -.-> | reads | Ingester["ingester"]
        Querier["querier"] -.-> | reads | StoreGateway["store-gateway"]
        
        Compactor["compactor"]
        Optional["`(optional) components ...`"]
    end

    subgraph Mimir2["mimir-2 -target=all"]
        Distributor2["distributor"] --> | writes| Ingester2["ingester"]

        QueryFrontend2["query-frontend"] -.-> | reads | Querier2["querier"]

        Querier2["querier"] -.-> | reads | Ingester2["ingester"]
        Querier2["querier"] -.-> | reads | StoreGateway2["store-gateway"]
        
        Compactor2["compactor"]
        Optional2["`(optional) components ...`"]
    end

    subgraph MimirN["mimir-n -target=all"]
        DistributorN["distributor"] --> | writes| IngesterN["ingester"]

        QueryFrontendN["query-frontend"] -.-> | reads | QuerierN["querier"]

        QuerierN["querier"] -.-> | reads | IngesterN["ingester"]
        QuerierN["querier"] -.-> | reads | StoreGatewayN["store-gateway"]
        
        CompactorN["compactor"]
        OptionalN["`(optional) components ...`"]
    end

    subgraph Minio
        ObjectStorage["Object Storage"]
    end


    Ingester  & Compactor    -->  | writes | ObjectStorage
    Compactor & StoreGateway -.-> | reads  | ObjectStorage

    Ingester2  & Compactor2    -->  | writes | ObjectStorage
    Compactor2 & StoreGateway2 -.-> | reads  | ObjectStorage

    IngesterN  & CompactorN    -->  | writes | ObjectStorage
    CompactorN & StoreGatewayN -.-> | reads  | ObjectStorage

```