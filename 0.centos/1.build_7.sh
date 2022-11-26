#!/bin/bash

docker pull centos:7
docker build -f Dockerfile_7 -t youken9980/centos:7 .
