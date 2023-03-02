#!/bin/bash

docker pull debian:bullseye-slim
docker build -f 2.Dockerfile-slim -t youken9980/debian:bullseye-slim .
