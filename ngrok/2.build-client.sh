#!/bin/bash

docker pull golang:1.12-alpine
docker build \
    --add-host "github.com:140.82.114.4" \
    --add-host "ghproxy.com:141.147.152.25" \
    --add-host "raw.staticdn.net:104.21.31.232" \
    --build-arg NGROK_DOMAIN="ngrok.me" \
    -f 2.Dockerfile-client \
    -t youken9980/ngrok:1.7-client .
