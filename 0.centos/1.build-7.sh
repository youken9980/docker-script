#!/bin/bash

docker pull centos:7
docker build -f 1.Dockerfile-7 -t youken9980/centos:7 .
