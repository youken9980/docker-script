#!/bin/bash

docker pull alpine:3.17
docker build -f 1.Dockerfile -t youken9980/alpine:3 .
