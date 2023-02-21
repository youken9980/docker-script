#!/bin/bash

docker pull debian:bullseye-slim
docker build -f Dockerfile-slim -t youken9980/debian:bullseye-slim .
