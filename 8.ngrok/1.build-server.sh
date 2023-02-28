#!/bin/bash

docker pull golang:1.12-alpine
docker build \
    --add-host "ghproxy.com:141.147.152.25" \
    --add-host "raw.staticdn.net:104.21.31.232" \
    --build-arg NGROK_DOMAIN="ngrok.me" \
    -f Dockerfile-server \
    -t youken9980/ngrok:1.7-server .
