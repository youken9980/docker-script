#!/bin/bash

docker pull golang:1.12-alpine
docker build --build-arg NGROK_DOMAIN="ngrok.me" -f Dockerfile-server -t youken9980/ngrok:1.7-server .
