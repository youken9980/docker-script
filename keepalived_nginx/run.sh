#!/bin/bash

imageTag="youken9980/keepalived-nginx:latest"
containerNamePrefix="keepalived-nginx"
network="mynet"
nodeCount=2
keepalivedRouterId="199"
keepalivedVirtualIp="172.18.0.199"
startPort="8090"

function dockerRm() {
    containerId=$(docker ps -aq --filter $1)
    runningContainerId=$(docker ps -aq --filter status=running --filter $1)
    if [ "${runningContainerId}" != "" ]; then
        docker stop ${runningContainerId}
    fi
    if [ "${containerId}" != "" ]; then
        docker rm ${containerId}
    fi
}

function dockerLogsUntil() {
    filter="$1"
    endpoint="$2"
    containerId=$(docker ps -aq --filter "${filter}")
    nohup docker logs -f "${containerId}" > "/tmp/${containerId}.log" 2>&1 &
    sleep 3s
    PID=$(ps aux | grep "docker" | grep ${containerId} | awk '{print $2}' | sort -nr | head -1)
    if [ "${PID}" != "" ]; then
        eval "tail -f --pid=${PID} /tmp/${containerId}.log | sed '/${endpoint}/q'"
        kill -9 ${PID}
        rm /tmp/${containerId}.log
    fi
}

dockerRm "ancestor=${imageTag}"
for i in $(seq ${nodeCount}); do
    containerName="${containerNamePrefix}-${i}"
    docker run -it -d --privileged -p $[$startPort + $i]:80 \
        -e KEEPALIVED_ROUTER_ID="${keepalivedRouterId}" \
        -e KEEPALIVED_VIRTUAL_IP="${keepalivedVirtualIp}" \
        --network="${network}" --name="${containerName}" \
        "${imageTag}"
done