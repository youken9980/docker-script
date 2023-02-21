#!/bin/bash

docker pull debian:bullseye
docker build -f Dockerfile -t youken9980/debian:bullseye .
