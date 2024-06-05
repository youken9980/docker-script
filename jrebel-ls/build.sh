#!/bin/bash

docker build \
    --add-host "maven.aliyun.com:59.110.251.11" \
    --build-arg "GITHUB_MIRROR=https://mirror.ghproxy.com/" \
    -f Dockerfile \
    -t youken9980/jrebel-ls:latest .
