FROM openjdk:8-jre-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

ENV TZ="Asia/Shanghai"

RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache tzdata && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    wget -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -O /glibc-2.32-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk && \
    apk add glibc-2.32-r0.apk && rm /glibc-2.32-r0.apk

STOPSIGNAL SIGTERM
