#!/bin/bash

docker pull centos:8
docker build -f Dockerfile_8 -t youken9980/centos:8 .
