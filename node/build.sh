#!/bin/bash

docker build -f Dockerfile \
    -t youken9980/node:14-alpine \
    -t youken9980/node:14-alpine-repository \
    .
