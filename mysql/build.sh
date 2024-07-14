#!/bin/bash

source ../.env.docker

docker build \
    --build-arg "DEBIAN_MIRROR=${DEBIAN_MIRROR}" \
    --build-arg "KEYSERVER=${KEYSERVER}" \
    -f Dockerfile \
    -t youken9980/mysql:5-debian \
    .
