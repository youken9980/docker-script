#!/bin/bash

configFile="$(pwd)/mycat.yml"
imageTag="youken9980/mycat2:latest"
containerName="mycat2"
network="mynet"

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
    sleep 1s
    PID=$(ps aux | grep "docker" | grep ${containerId} | awk '{print $2}' | sort -nr | head -1)
    if [ "${PID}" != "" ]; then
        eval "tail -f --pid=${PID} /tmp/${containerId}.log | sed '/${endpoint}/q'"
        kill -9 ${PID}
        rm /tmp/${containerId}.log
    fi
}

dockerRm "name=${containerName}"
docker run -d -p 8066:8066 \
    -v "${configFile}":/usr/local/mycat/conf/mycat.yml \
    --network="${network}" --name="${containerName}" \
    "${imageTag}"
dockerLogsUntil "name=${containerName}" "[[:space:]]mycat[[:space:]]starts[[:space:]]successful"
