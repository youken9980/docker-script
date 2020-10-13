#!/bin/bash

imageTag="youken9980/centos:latest"

function dockerRm() {
    containerId=$(docker ps -aq --filter ancestor="${imageTag}")
    if [ "${containerId}" != "" ]; then
        docker rm $(docker stop "${containerId}")
    fi
}

dockerRm
docker run -it --rm "${imageTag}"
