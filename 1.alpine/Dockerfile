FROM alpine:3
LABEL maintainer="YangJian <youken9980@163.com>"

ARG GLIBC_VERSION="2.32-r0"
ENV TZ="Asia/Shanghai"

RUN sed -i "s|dl-cdn.alpinelinux.org|mirrors.tuna.tsinghua.edu.cn|g" /etc/apk/repositories && \
    apk update && \
    apk add tzdata && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    \
    apk add ca-certificates && \
    wget -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -O /glibc-${GLIBC_VERSION}.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    apk add glibc-${GLIBC_VERSION}.apk && \
    rm -rf glibc-${GLIBC_VERSION}.apk

STOPSIGNAL SIGTERM
