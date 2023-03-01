#!/bin/bash

docker build \
    --add-host "ghproxy.com:141.147.152.25" \
    --add-host "raw.staticdn.net:104.21.31.232" \
    --add-host "maven.aliyun.com:59.110.251.10" \
    -f Dockerfile \
    -t youken9980/keepalived-mycat2:latest .
