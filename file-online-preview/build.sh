#!/bin/bash

docker build \
    --add-host "maven.aliyun.com:59.110.251.11" \
    --add-host "releases.aspose.com:18.160.78.38" \
    --add-host "repository.aspose.com:18.160.18.26" \
    -f Dockerfile \
    -t youken9980/file-online-preview:latest .
