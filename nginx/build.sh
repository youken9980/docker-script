#!/bin/bash

source ../.env.docker

docker build \
    --build-arg "ALPINE_MIRROR=${ALPINE_MIRROR}" \
    -f Dockerfile \
    -t youken9980/nginx:stable-alpine-slim \
    .
