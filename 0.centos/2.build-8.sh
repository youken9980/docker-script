#!/bin/bash

docker pull centos:8
docker build -f 2.Dockerfile-8 -t youken9980/centos:8 .
