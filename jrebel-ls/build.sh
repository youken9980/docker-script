#!/bin/bash

docker build \
    --add-host "maven.aliyun.com:59.110.251.11" \
    -f Dockerfile \
    -t youken9980/jrebel-ls:latest .
