#!/bin/bash

docker pull adoptopenjdk:16-jre
docker build -f Dockerfile -t youken9980/papermc:1.17.1-157 .
