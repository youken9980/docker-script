#!/bin/bash

docker pull nginx:1.24-alpine-slim
docker build -f Dockerfile -t youken9980/nginx:1.24-alpine-slim .
