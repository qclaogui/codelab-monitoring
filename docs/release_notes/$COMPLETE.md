
# Release v$COMPLETE

A simple command to run Grafana LGTMP Stack in Docker or Kubernetes.

## What's Changed

This release contains minor changes and bugfixes.

## New Contributors

No contributors

🎉 **Thanks to all contributors helping with this release!** 🎉

---
> [!WARNING]
> Release Drafter could not find a previous **published release** for `qclaogui/codelab-monitoring`. This draft was created **without a comparison baseline**.

> [!IMPORTANT]
> Treat this draft as a manual starting point.
> Review the proposed version, tag, and notes before publishing.

If you did not expect this to happen, [open an issue](https://github.com/release-drafter/release-drafter/issues/new?template=previous-published-release-not-found.yml).

---
## Grafana LGTMP Stack default port-mapping

| Port-mapping | Component | Description |
| --- | --- | --- |
| `12345:12345`, `4317`, `4318`, `6831` | [Alloy][1] | Eexpose `12345` port so we can directly access `alloy` inside container |
| `33100:3100` | [Loki][2] | Expose `33100` port so we can directly access `loki` inside container |
| `3000:3000`, `6060` | [Grafana][3] | Expose `3000` port so we can directly access `grafana` inside container |
| `33200:3200`, `4317`, `4318` | [Tempo][4] | Expose `33200` port so we can directly access `tempo` inside container |
| `38080:8080` | [Mimir][5] | Expose `38080` port so we can directly access `mimir` inside container |
| `34040:4040` | [Pyroscope][6] | Expose `34040` port so we can directly access `pyroscope` inside container |
| `9001:9001`, `9000` | [Minio][7] | Expose `9001` port so we can access `minio` console with `MINIO_ROOT_USER=lgtmp`, `MINIO_ROOT_PASSWORD=supersecret` |
| `39000:9000`, `2500`, `1100` | [Inbucket][8] | Expose `39000` port to use for the email testing server web interface. |

[1]: https://github.com/grafana/alloy
[2]: https://github.com/grafana/loki
[3]: https://github.com/grafana/grafana
[4]: https://github.com/grafana/tempo
[5]: https://github.com/grafana/mimir
[6]: https://github.com/grafana/pyroscope
[7]: https://github.com/minio/minio
[8]: https://github.com/inbucket/inbucket

## Helpful Links

- <https://grafana.com/docs/alloy/latest/>
- <https://github.com/grafana/alloy-modules>
- <https://github.com/docker/compose>
- <https://github.com/k3d-io/k3d>
- <https://github.com/k3s-io/k3s>
- [Grafana Alloy Configuration Generator](https://github.com/grafana/alloy-configurator) s an easy to use web interface for creating and editing alloy configuration files. It targets the flow configuration format.

