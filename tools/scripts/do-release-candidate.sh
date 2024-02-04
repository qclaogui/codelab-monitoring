#!/bin/bash -ex

source .bingo/variables.env

if [ -z "${GITHUB_REF_NAME}" ] || [ "${GITHUB_REF_TYPE}" != "tag" ] ; then
  echo "Expected a tag push event, skipping release workflow"
  exit 1
fi

tag="${GITHUB_REF_NAME}"

export RELEASE_DESCRIPTION="${tag}"
RELEASE_NOTES_FILE="docs/release_notes/${tag/-rc.*}.md"

if [ ! -f "${RELEASE_NOTES_FILE}" ]; then
    echo "Release notes file ${RELEASE_NOTES_FILE} does not exist. Exiting..."
    exit 1
fi

cat ./.goreleaser.yml ./.goreleaser.brew.yml > .goreleaser.combined.yml
GORELEASER_CURRENT_TAG="v${tag}" RELEASE_BUILD=1 PRE_RELEASE_ID="${tag#*-}" ${GORELEASER} release --clean --timeout 60m --skip=validate --config=./.goreleaser.combined.yml --release-notes="${RELEASE_NOTES_FILE}"
