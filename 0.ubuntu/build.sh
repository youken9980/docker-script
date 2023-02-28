#!/bin/bash

docker pull ubuntu:jammy
docker build -f Dockerfile -t youken9980/ubuntu:jammy .
