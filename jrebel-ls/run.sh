#!/bin/bash

imageTag="youken9980/jrebel-ls:latest"
containerName="jrebel-ls"

function dockerRm() {
    containerId=$(docker ps -aq --filter name="${containerName}")
    if [ "${containerId}" != "" ]; then
        docker rm $(docker stop "${containerId}")
    fi
}

dockerRm
docker run -d -p 8079:8080 \
    -e PORT=8080 \
    --restart always \
    --name "${containerName}" \
    "${imageTag}"
docker logs -f "${containerName}"
