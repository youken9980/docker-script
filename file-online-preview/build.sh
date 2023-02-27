#!/bin/bash

docker pull openjdk:8-jre-slim-bullseye
docker build \
    --add-host "ghproxy.com:141.147.152.25" \
    --add-host "raw.staticdn.net:104.21.31.232" \
    -f Dockerfile \
    -t youken9980/file-online-preview:latest .
