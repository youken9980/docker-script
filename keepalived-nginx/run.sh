#!/bin/bash

imageTag="youken9980/keepalived-nginx:latest"
containerNamePrefix="keepalived-nginx"
network="mynet"
nodeCount=2
keepalivedRouterId="199"
keepalivedVirtualIp="172.18.0.199"
startPort="8090"
publishPort="true"

function dockerRm() {
    filter="$1"
    containerId=$(docker ps -aq --filter "${filter}")
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

for node in $(eval echo ${nodeList}); do
    containerName="${containerNamePrefix}-${node}"
    dockerRm "name=${containerName}"
done

port="${startPort}"
for i in $(seq ${nodeCount}); do
    containerName="${containerNamePrefix}-${i}"
    docker run --privileged -d -p ${port}:80 \
        -e KEEPALIVED_ROUTER_ID="${keepalivedRouterId}" \
        -e KEEPALIVED_VIRTUAL_IP="${keepalivedVirtualIp}" \
        --network="${network}" --name="${containerName}" \
        "${imageTag}"
    port=$[$port + 1]
done
