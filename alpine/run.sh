#!/bin/bash

imageTag="youken9980/openssh-server:alpine"

function dockerRm() {
    containerId=$(docker ps -aq --filter $1)
    runningContainerId=$(docker ps -aq --filter status=running --filter $1)
    if [ "${runningContainerId}" != "" ]; then
        docker stop ${runningContainerId}
    fi
    if [ "${containerId}" != "" ]; then
        docker rm ${containerId}
    fi
}

dockerRm "ancestor=${imageTag}"
docker run -d -p 22:22 "${imageTag}"
docker exec -it $(docker ps -aq --filter ancestor="${imageTag}") /bin/sh
