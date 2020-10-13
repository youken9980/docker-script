#!/bin/bash

imageTag="youken9980/jrebel-ls:latest"
containerName="jrebel-ls"

docker rm $(docker stop "${containerName}")
docker run -d -p 8079:8080 \
    -e PORT=8080 \
    --restart always \
    --name "${containerName}" \
    "${imageTag}"
docker logs -f "${containerName}"
