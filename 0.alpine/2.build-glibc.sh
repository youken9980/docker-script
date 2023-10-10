#!/bin/bash

docker build \
    --add-host "ghps.cc:104.21.49.44" \
    --add-host "ghproxy.com:141.147.152.25" \
    --add-host "raw.staticdn.net:104.21.31.232" \
    --add-host "alpine-pkgs.sgerrand.com:172.67.200.21" \
    -f 2.Dockerfile-glibc \
    -t youken9980/alpine:3-glibc .
