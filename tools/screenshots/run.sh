#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd `dirname $0` && pwd)
DOCKER_APP_IMAGE="mixin-screenshots-taker"
DOCKER_APP_NAME="mixin-screenshots-taker"

# Build the Docker image.
echo "Building Docker image ${DOCKER_APP_IMAGE}"
docker build -t "${DOCKER_APP_IMAGE}" "${SCRIPT_DIR}"

# Start application to take screenshots.
echo "Start screenshot taker container with name ${DOCKER_APP_NAME}"
docker run \
  --rm \
  --name "$DOCKER_APP_NAME" \
  --env "CLUSTER=docker-compose" \
  --env "MIMIR_NAMESPACE=monitoring-system" \
  --env "ALERTMANAGER_NAMESPACE=monitoring-system" \
  --env "MIMIR_USER=anonymous" \
  -v "${SCRIPT_DIR}/../../docker-compose/common/config/grafana/provisioning/dashboards:/input" \
  -v "${SCRIPT_DIR}/../../docs/dashboards:/output" \
  "${DOCKER_APP_IMAGE}"