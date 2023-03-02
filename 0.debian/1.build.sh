#!/bin/bash

docker pull debian:bullseye
docker build -f 1.Dockerfile -t youken9980/debian:bullseye .
