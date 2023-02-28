#!/bin/bash

docker build \
    --add-host "ghproxy.com:141.147.152.25" \
    --add-host "raw.staticdn.net:104.21.31.232" \
    -f 3.Dockerfile_17-jre-jammy \
    -t youken9980/openjdk:17-jre-jammy .
