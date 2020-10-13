#!/bin/bash

imageTag="youken9980/openssh-server:alpine"

function dockerRm() {
    containerId=$(docker ps -aq --filter ancestor="${imageTag}")
    if [ "${containerId}" != "" ]; then
        docker rm $(docker stop "${containerId}")
    fi
}

dockerRm
docker run -d -p 22:22 "${imageTag}"
docker exec -it $(docker ps -aq --filter ancestor="${imageTag}") /bin/sh
