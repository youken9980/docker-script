#!/bin/bash

imageTag="youken9980/alpine-xfce4-novnc:latest"
vncPort="5900"
novncPort="6080"
vncResolution="1280x800"
vncPasswd="alpinelinux"

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

dockerRm "ancestor=${imageTag}"
docker run --privileged -d \
    -p ${vncPort}:${vncPort} \
    -p ${novncPort}:${novncPort} \
    -e VNC_PORT=${vncPort} \
    -e NOVNC_PORT=${novncPort} \
    -e VNC_RESOLUTION=${vncResolution} \
    -e VNC_PASSWD=${vncPasswd} \
    --network=mynet \
    --name alpine-xfce4-novnc \
    ${imageTag}
