#!/bin/bash

IMAGE_TAG="youken9980/openssh-server:alpine"

function dockerRm() {
    CONTAINER_ID=$(docker ps -aq --filter ancestor="${IMAGE_TAG}")
    if [ "${CONTAINER_ID}" != "" ]; then
        docker rm $(docker stop "${CONTAINER_ID}")
    fi
}

dockerRm
docker run -d -p 22:22 "${IMAGE_TAG}"
docker exec -it $(docker ps -aq --filter ancestor="${IMAGE_TAG}") /bin/sh
