#!/bin/bash

set -eu

cleanup="false"
imageTag="jenkins/jenkins:lts-alpine"
containerName="jenkins-master"
network="mynet"
dataHome="~/dockerVolume/jenkins/master/data"
dataHome="$(eval readlink -f ${dataHome})"

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
        --cpus 4 --memory 2048M --memory-swap -1 \
        -e TZ="Asia/Shanghai" \
        -e JAVA_OPTS="-Duser.timezone=Asia/Shanghai -Dfile.encoding=UTF8 -Dsun.jnu.encoding=UTF8" \
        -e JENKINS_OPTS="--requestHeaderSize=32768" \
        -v /var/run/docker.sock:/var/run/docker.sock:rw \
        -v ${dataHome}:/var/jenkins_home \
        --network="${network}" --name=${containerName} \
        ${imageTag}
    # /var/run/docker.sock 权限必须是666，jenkins-master的jenkins用户才能运行docker
    docker exec -u root -it ${containerName} chmod 666 /var/run/docker.sock
    dockerLogsUntil "ancestor=${imageTag}" "Jenkins[[:space:]]is[[:space:]]fully[[:space:]]up[[:space:]]and[[:space:]]running"
}

function sedSource() {
    # 替换为国内源
    eval "sed -i 's/https:\/\/updates.jenkins.io\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' ${dataHome}/updates/default.json"
    eval "sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' ${dataHome}/updates/default.json"
    eval "sed -i 's/https:\/\/updates.jenkins.io/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins\/updates/g' ${dataHome}/hudson.model.UpdateCenter.xml"
}

dockerRm "name=${containerName}"
if [ "${cleanup}" = "true" ]; then
    rebuid "${dataHome}"
    dockerRun
    dockerRm "name=${containerName}"
    sedSource
fi
dockerRun

# /usr/share/jenkins/jenkins.war

# Jenkins initial setup is required. An admin user has been created and a password generated.
# This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

# 使用低版本插件，新版有bug
# https://mirrors.tuna.tsinghua.edu.cn/jenkins/plugins/jackson2-api/2.11.3/jackson2-api.hpi
# https://mirrors.tuna.tsinghua.edu.cn/jenkins/plugins/junit/1.46/junit.hpi

# 已安装工具的路径和版本号
# 在jenkins-master只配置名称不配置路径，路径在jenkins-agent的工具位置中配置
# /opt/java/openjdk/bin/java jdk-8u272
# /usr/bin/git git-2.26.2
# /usr/local/gradle/bin/gradle gradle-6.7.1
# /usr/local/maven/bin/mvn maven-3.6.3
# /usr/bin/docker docker-19.03.12

# Docker (Host) URL:
# unix:///var/run/docker.sock

# Docker Image
# jenkins/inbound-agent:alpine

# User
# jenkins

# Volumes
# 冒号左边是宿主机路径，不是jenkins-master容器路径，冒号右边是jenkins-agent容器路径。左右都用绝对路径
# /var/run/docker.sock:/var/run/docker.sock
# ~/share/gradle-6.7.1/:/usr/local/gradle/
# ~/share/gradle-repository/:/usr/local/gradle-repository/
# ~/share/apache-maven-3.6.3/:/usr/local/maven/
# ~/share/maven-repository:/usr/local/maven-repository/

# Volumes From
# jenkins-master

# Environment
# GRADLE_REPO=/usr/local/gradle-repository
# GRADLE_USER_HOME=${GRADLE_REPO}
# MAVEN_REPO=/usr/local/maven-repository
# MAVEN_REPOSITORY=${MAVEN_REPO}
# M2_REPO=${MAVEN_REPO}

# Remote File System Root
# /home/jenkins

# Node Properties
# 工具位置列表
# 参照上面「已安装工具的路径和版本号」选择工具并配置路径

# Maven
# clean
# package
# -P$MAVEN_PROFILE
# -Dmaven.test.skip=true
# -U
