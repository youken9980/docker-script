# maven package

FROM maven:3-openjdk-8-slim as maven
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
    apt-get install -y git

RUN mkdir /app && cd /app && \
    git clone --depth=1 https://gitee.com/gsls200808/JrebelLicenseServerforJava.git && \
    cd JrebelLicenseServerforJava && \
    mvn clean package -Dmaven.test.skip=true


# build jrebel

FROM openjdk:8-jre-alpine as jrebel
LABEL maintainer="YangJian <youken9980@163.com>"

RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories && \
    apk update && \
    apk add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

ENV PORT 8080

COPY --from=maven /app/JrebelLicenseServerforJava/target/JrebelBrainsLicenseServerforJava-1.0-SNAPSHOT.jar /service.jar
CMD java -jar /service.jar -p $PORT
