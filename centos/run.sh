#!/bin/bash

imageTag="youken9980/centos:latest"

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
docker run -it --rm "${imageTag}"
