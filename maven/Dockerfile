FROM maven:3-openjdk-8-slim
LABEL maintainer="YangJian <youken9980@163.com>"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list && \
    sed -i '/    <!-- mirror/i\    <mirror>' /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <id>aliyunmaven</id>' /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <mirrorOf>*</mirrorOf>' /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <name>阿里云公共仓库</name>' /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <url>https://maven.aliyun.com/repository/public</url>' /usr/share/maven/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\    </mirror>' /usr/share/maven/conf/settings.xml && \
    apt-get update && \
    apt-get install -y --no-install-recommends git subversion libxml-xpath-perl

WORKDIR /usr/local/src
