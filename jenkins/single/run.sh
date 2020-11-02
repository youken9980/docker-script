#!/bin/bash

imageTag="youken9980/jenkins-single:latest"
containerName="jenkins-single"
network="mynet"
dataHome="~/dockerVolume/jenkins/single/data"
mavenRepository="~/maven-repository"
gradleRepository="~/gradle-repository"

dataHome="$(eval readlink -m ${dataHome})"
mavenRepository="$(eval readlink -f ${mavenRepository})"
gradleRepository="$(eval readlink -f ${gradleRepository})"
eval "mkdir -p ${dataHome}"

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

function dockerRun() {
    # 默认情况下，基于JNLP的Jenkins代理通过TCP端口50000与Jenkins主站进行通信。 -p 50000:50000
    docker run -d -p 8089:8080 \
        -e JAVA_OPTS="-Duser.timezone=Asia/Shanghai -Dfile.encoding=UTF8 -Dsun.jnu.encoding=UTF8" \
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
dockerRun
sedSource
dockerRm "ancestor=${imageTag}"
dockerRun

# 已安装工具的路径和版本号
# /opt/java/openjdk/bin/java jdk-8u262
# /usr/bin/git git-2.26.2
# /app/gradle-6.6.1/bin/gradle
# /app/apache-maven-3.6.3/bin/mvn
