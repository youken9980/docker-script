#!/bin/bash

imageTag="youken9980/nginx:stable-alpine"
containerNamePrefix="nginx"
network="mynet"
nodeCount=2
startPort="8090"
publishPort="true"
keepalivedRouterId="199"
keepalivedVirtualIp="172.18.0.199"
runKeepalived="true"

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
    PID=$(ps aux | grep "docker" | grep ${containerId} | awk '{print $2}' | sort -nr | head -1)
    if [ "${PID}" != "" ]; then
        eval "tail -f --pid=${PID} /tmp/${containerId}.log | sed '/${endpoint}/q'"
        kill ${PID}
        rm /tmp/${containerId}.log
    fi
}

for i in $(seq ${nodeCount}); do
    containerName="${containerNamePrefix}-${i}"
    dockerRm "name=${containerName}"
done

port="${startPort}"
for i in $(seq ${nodeCount}); do
    publish=""
    if [ "${publishPort}" = "first" -a "${port}" = "${startPort}" -o "${publishPort}" = "true" ]; then
        publish="-p ${port}:80"
    fi
    containerName="${containerNamePrefix}-${i}"
    docker run --privileged -d ${publish} \
        --cpus 0.1 --memory 32M --memory-swap -1 \
        -e RUN_KEEPALIVED="${runKeepalived}" \
        -e KEEPALIVED_ROUTER_ID="${keepalivedRouterId}" \
        -e KEEPALIVED_VIRTUAL_IP="${keepalivedVirtualIp}" \
        --network="${network}" --name="${containerName}" \
        "${imageTag}"
    dockerLogsUntil "name=${containerName}" "[[:space:]]ready[[:space:]]for[[:space:]]start[[:space:]]up"
    port=$[$port + 1]
done
