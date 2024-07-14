#!/bin/bash

source ../.env.docker

docker build \
    --build-arg "GITHUB_MIRROR=${GITHUB_MIRROR}" \
    -f Dockerfile-temurin8 \
    -t youken9980/build-tools-temurin8:latest \
    .
