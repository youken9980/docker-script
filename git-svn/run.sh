#!/bin/bash

imageTag="youken9980/git-svn:latest"
network="mynet"

function dockerRm() {
    filter="$1"
    containerId=$(docker ps -aq --filter "${filter}")
    runningContainerId=$(docker ps -aq --filter status=running --filter $1)
    if [ "${runningContainerId}" != "" ]; then
        docker stop ${runningContainerId}
    fi
    if [ "${containerId}" != "" ]; then
        docker rm ${containerId}
    fi
}

dockerRm "ancestor=${imageTag}"
docker run --rm -it \
    -e GIT_USER_NAME="ycg" \
    -e GIT_USER_EMAIL="ycg@ycg.com" \
    -v ~/Destiny/YunCaiGong/git:/root \
    --net "${network}" \
    "${imageTag}"
