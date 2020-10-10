#!/bin/bash

IMAGE_TAG="youken9980/centos:latest"

function dockerRm() {
    CONTAINER_ID=$(docker ps -aq --filter ancestor="${IMAGE_TAG}")
    if [ "${CONTAINER_ID}" != "" ]; then
        docker rm $(docker stop "${CONTAINER_ID}")
    fi
}

dockerRm
docker run -it --rm "${IMAGE_TAG}"
