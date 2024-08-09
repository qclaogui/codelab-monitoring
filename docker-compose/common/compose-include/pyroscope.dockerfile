FROM docker.io/grafana/pyroscope:1.7.1

COPY --from=busybox:1.36.0-musl /bin/wget /usr/bin/wget