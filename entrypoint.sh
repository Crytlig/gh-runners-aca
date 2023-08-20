#!/bin/bash

set -eEo pipefail

echo "HELLO"
GH_OWNER=$GH_OWNER
GH_REPOSITORY=$GH_REPOSITORY
GH_TOKEN=$GH_TOKEN

echo "GH_OWNER == $GH_OWNER"

echo "GH_REPOSITORY == $GH_REPOSITORY"
echo "GH_TOKEN == $GH_TOKEN"


RUNNER_SUFFIX=$(echo ${RANDOM:0:8})
RUNNER_NAME="dockerNode-${RUNNER_SUFFIX}"

REG_TOKEN=$(curl -sX POST -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${GH_TOKEN}" https://api.github.com/repos/${GH_OWNER}/${GH_REPOSITORY}/actions/runners/registration-token \
    | jq .token --raw-output)


GROUP=${RUNNER_GROUP:-"default"}
RUNNER_LABELS="aca"

cd /home/docker/actions-runner

echo "Configuring GitHub Actions Runner and registering"
./config.sh \
    --unattended \
    --url https://github.com/${GH_OWNER}/${GH_REPOSITORY} \
    --token "${REG_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --work "${RUNNER_WORK_DIRECTORY}" \
    --runnergroup "${GROUP}" \
    --ephemeral \
    --labels "${RUNNER_LABELS}"

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
