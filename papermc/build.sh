#!/bin/bash

source ../.env.docker

docker build \
    -f Dockerfile \
    -t youken9980/papermc:1.20.6-147 \
    .
