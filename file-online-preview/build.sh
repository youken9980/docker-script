#!/bin/bash

docker build \
    --add-host "releases.aspose.com:18.160.18.60" \
    --add-host "maven.aliyun.com:59.110.251.11" \
    --add-host "repository.aspose.com:3.160.196.16" \
    -f Dockerfile \
    -t youken9980/file-online-preview:latest .
