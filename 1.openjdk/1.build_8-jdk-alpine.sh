#!/bin/bash

docker build \
    --add-host "ghproxy.com:141.147.152.25" \
    --add-host "raw.staticdn.net:104.21.31.232" \
    -f 1.Dockerfile_8-jdk-alpine \
    -t youken9980/openjdk:8-jdk-alpine .
