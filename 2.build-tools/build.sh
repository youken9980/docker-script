#!/bin/bash

docker build -f Dockerfile -t youken9980/build-tools-temurin8:latest .
docker tag youken9980/build-tools-temurin8:latest youken9980/build-tools-temurin8:repository
