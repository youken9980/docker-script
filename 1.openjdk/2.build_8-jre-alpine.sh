#!/bin/bash

docker build \
    --add-host "ghps.cc:104.21.49.44" \
    --add-host "ghproxy.com:141.147.152.25" \
    --add-host "raw.staticdn.net:104.21.31.232" \
    -f 2.Dockerfile_8-jre-alpine \
    -t youken9980/openjdk:8-jre-alpine .
