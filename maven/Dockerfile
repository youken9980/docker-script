FROM maven:3-openjdk-8-slim
LABEL maintainer="YangJian <youken9980@163.com>"

RUN sed -i "s|# export LS_OPTIONS='--color=auto'|export LS_OPTIONS='--color=auto'|g" /root/.bashrc && \
    sed -i "s|# alias ls='ls \$LS_OPTIONS'|alias ls='ls \$LS_OPTIONS'|g" /root/.bashrc && \
    sed -i "s|# alias ll='ls \$LS_OPTIONS -l'|alias ll='ls \$LS_OPTIONS -l'|g" /root/.bashrc && \
    sed -i "s|# alias l='ls \$LS_OPTIONS -lA'|alias l='ls \$LS_OPTIONS -lA'|g" /root/.bashrc && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo Asia/Shanghai > /etc/timezone && \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends git subversion libxml-xpath-perl

ARG MAVEN_REPO="/root/.m2"
ENV MAVEN_REPOSITORY $MAVEN_REPO
ENV M2_REPO $MAVEN_REPO

RUN mkdir -p $MAVEN_REPO && \
    chmod 777 $MAVEN_REPO && \
    chmod 755 /root && \
    sed -i "/  <!-- localRepository/i\  <localRepository>$MAVEN_REPO</localRepository>" /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\    <mirror>' /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <id>aliyunmaven</id>' /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <mirrorOf>*</mirrorOf>' /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <name>阿里云公共仓库</name>' /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <url>https://maven.aliyun.com/repository/public</url>' /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\    </mirror>' /usr/share/maven/conf/settings.xml

WORKDIR /usr/local/src

STOPSIGNAL SIGTERM
