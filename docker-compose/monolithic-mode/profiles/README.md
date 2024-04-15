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
    subgraph Agent["Grafana Alloy"]
        A("alloy")
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

## Quick Start

```shell
git clone https://github.com/qclaogui/codelab-monitoring.git && cd "$(basename "$_" .git)"

make up-monolithic-mode-profiles
```

That's it.

Once all containers are up and running you can search for profiles in Grafana.

Navigate to [http://localhost:3000/explore](http://localhost:3000/explore) and select the search tab.

## Clean up

```shell
make down-monolithic-mode-profiles
```
