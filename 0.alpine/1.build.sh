#!/bin/bash

docker pull alpine:3
docker build -f Dockerfile -t youken9980/alpine:3 .
