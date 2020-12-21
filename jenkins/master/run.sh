#!/bin/bash

cleanup="false"
imageTag="youken9980/jenkins-master:latest"
containerName="jenkins-master"
network="mynet"
dataHome="~/dockerVolume/jenkins/master/data"
dataHome="$(eval readlink -f ${dataHome})"
mavenRepository="~/maven-repository"
mavenRepository="$(eval readlink -f ${mavenRepository})"
gradleRepository="~/gradle-repository"
gradleRepository="$(eval readlink -f ${gradleRepository})"

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

function rebuid() {
    path=$1
    if [ -e "${path}" ]; then
        eval "rm -rf ${path}"
    fi
    eval "mkdir -p ${path}"
}

function dockerRun() {
    # 默认情况下，基于JNLP的Jenkins代理通过TCP端口50000与Jenkins主站进行通信。 -p 50000:50000
    docker run -d -p 8090:8080 \
        -e JAVA_OPTS="-Duser.timezone=Asia/Shanghai -Dfile.encoding=UTF8 -Dsun.jnu.encoding=UTF8" \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ${dataHome}:/var/jenkins_home \
        -v ${mavenRepository}:/app/maven-repository \
        -v ${gradleRepository}:/app/gradle-repository \
        --network="${network}" --name=${containerName} \
        ${imageTag}
    dockerLogsUntil "ancestor=${imageTag}" "Jenkins[[:space:]]is[[:space:]]fully[[:space:]]up[[:space:]]and[[:space:]]running"
}

function sedSource() {
    # 替换为国内源
    eval "sed -i 's/https:\/\/updates.jenkins.io\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' ${dataHome}/updates/default.json"
    eval "sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' ${dataHome}/updates/default.json"
    eval "sed -i 's/https:\/\/updates.jenkins.io/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins\/updates/g' ${dataHome}/hudson.model.UpdateCenter.xml"
}

dockerRm "ancestor=${imageTag}"
if [ "${cleanup}" = "true" ]; then
    rebuid "${dataHome}"
    dockerRun
    dockerRm "ancestor=${imageTag}"
    sedSource
fi
dockerRun

# /usr/share/jenkins/jenkins.war

# Jenkins initial setup is required. An admin user has been created and a password generated.
# This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

# 已安装工具的路径和版本号
# /opt/java/openjdk/bin/java jdk-8u272
# /usr/bin/git git-2.26.2
# /app/gradle-6.7.1/bin/gradle
# /app/apache-maven-3.6.3/bin/mvn
# /usr/bin/docker

# Docker (Host) URL: unix:///var/run/docker.sock
