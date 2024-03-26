#!/bin/bash -ex

source .bingo/variables.env

if [ -z "${GITHUB_REF_NAME}" ] || [ "${GITHUB_REF_TYPE}" != "tag" ] ; then
    echo "Expected a tag push event, skipping release workflow"
    exit 1
fi

tag="${GITHUB_REF_NAME}"

export RELEASE_DESCRIPTION="v${tag} (permalink)"
RELEASE_NOTES_FILE="docs/release_notes/${tag}.md"

if [ ! -f "${RELEASE_NOTES_FILE}" ]; then
    echo "Release notes ${RELEASE_NOTES_FILE} not found. Exiting..."
    exit 1
fi
cat .github/.goreleaser.yml .github/.goreleaser.brew.yml > .github/.goreleaser.combined.yml
RELEASE_BUILD=1 GORELEASER_CURRENT_TAG=v${tag} PRE_RELEASE_ID="" ${GORELEASER} release --clean --timeout 60m --skip=validate --config=.github/.goreleaser.combined.yml --release-notes="${RELEASE_NOTES_FILE}"
