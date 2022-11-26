#!/bin/bash

docker pull openjdk:8-jre-slim-bullseye
docker build -f Dockerfile -t youken9980/file-online-preview:latest .
