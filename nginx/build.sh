#!/bin/bash

docker pull nginx:1.22-alpine
docker build -f Dockerfile -t youken9980/nginx:1.22-alpine .
