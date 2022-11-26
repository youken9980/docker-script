#!/bin/bash

docker pull ubuntu:20.04
docker build -f Dockerfile -t youken9980/ubuntu:20.04 .
