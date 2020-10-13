#!/bin/bash

imageTag="youken9980/jenkins-master:latest"
containerName="jenkins-master"
dataHome="~/dockerVolume/jenkins/master/data"
mavenRepository="~/maven-repository"
gradleRepository="~/gradle-repository"

dataHome="$(eval readlink -m ${dataHome})"
mavenRepository="$(eval readlink -f ${mavenRepository})"
gradleRepository="$(eval readlink -f ${gradleRepository})"
eval "mkdir -p ${dataHome}"

function dockerRm() {
    containerId=$(docker ps -aq --filter ancestor="${imageTag}")
    if [ "${containerId}" != "" ]; then
        docker rm $(docker stop "${containerId}")
    fi
}

function dockerRun() {
    # 默认情况下，基于JNLP的Jenkins代理通过TCP端口50000与Jenkins主站进行通信。 -p 50000:50000
    docker run -d -p 8091:8080 \
        -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai \
        -v ${dataHome}:/var/jenkins_home \
        -v ${mavenRepository}:/app/maven-repository \
        -v ${gradleRepository}:/app/gradle-repository \
        --network bridge --name ${containerName} \
        ${imageTag}
    containerId=$(docker ps -aq --filter ancestor="${imageTag}")
    nohup docker logs -f "${containerId}" > "/tmp/${containerId}.log" 2>&1 &
    sleep 3s
    PID=$(ps aux | grep "docker logs" | grep ${containerId} | awk '{print $2}' | sort -nr | head -1)
    tail -f --pid=${PID} /tmp/${containerId}.log | sed '/Jenkins[[:space:]]is[[:space:]]fully[[:space:]]up[[:space:]]and[[:space:]]running/q'
    kill -9 ${PID}
    rm /tmp/${containerId}.log
}

function sedSource() {
    # 替换为国内源
    eval "sed -i 's/https:\/\/updates.jenkins.io\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' ${dataHome}/updates/default.json"
    eval "sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' ${dataHome}/updates/default.json"
    eval "sed -i 's/https:\/\/updates.jenkins.io/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins\/updates/g' ${dataHome}/hudson.model.UpdateCenter.xml"
}

dockerRm
dockerRun
sedSource
dockerRm
dockerRun

# 已安装工具的路径和版本号
# /opt/java/openjdk/bin/java jdk-8u262
# /usr/bin/git git-2.26.2
# /app/gradle-6.6.1/bin/gradle
# /app/apache-maven-3.6.3/bin/mvn
# /usr/bin/docker

# Docker (Host) URL: unix:///var/run/docker.sock
