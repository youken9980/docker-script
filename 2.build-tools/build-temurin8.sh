#!/bin/bash

docker build -f Dockerfile-temurin8 \
    -t youken9980/build-tools-temurin8:latest \
    -t youken9980/build-tools-temurin8:repository \
    .
