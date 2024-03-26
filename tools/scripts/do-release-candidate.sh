#!/bin/bash -ex

source .bingo/variables.env

if [ -z "${GITHUB_REF_NAME}" ] || [ "${GITHUB_REF_TYPE}" != "tag" ] ; then
  echo "Expected a tag push event, skipping release workflow"
  exit 1
fi

tag="${GITHUB_REF_NAME}"

RELEASE_NOTES_FILE="docs/release_notes/${tag/-rc.*}.md"

if [ ! -f "${RELEASE_NOTES_FILE}" ]; then
    echo "Release notes file ${RELEASE_NOTES_FILE} does not exist. Exiting..."
    exit 1
fi

# Update version to release-candidate
pre_release_id="${tag#*-}"

export RELEASE_DESCRIPTION="v${tag}"

cat .github/.goreleaser.yml > .github/.goreleaser.combined.yml
RELEASE_BUILD=1 GORELEASER_CURRENT_TAG="v${tag}" PRE_RELEASE_ID="${pre_release_id}" ${GORELEASER} release --clean --timeout 60m --skip=validate --config=.github/.goreleaser.combined.yml --release-notes="${RELEASE_NOTES_FILE}"
