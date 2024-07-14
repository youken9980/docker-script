#!/bin/bash

source ../.env.docker

docker build \
    --build-arg "ALPINE_MIRROR=${ALPINE_MIRROR}" \
    -f Dockerfile-8-jre-alpine \
    -t youken9980/temurin:8-jre-alpine \
    .
