FROM ubuntu:20.04
LABEL maintainer="YangJian <youken9980@163.com>"

ENV SHELL="/bin/bash"
ENV TZ="Asia/Shanghai"

RUN set -eux && \
    UBUNTU_MIRROR="https://mirrors.tuna.tsinghua.edu.cn" && \
    \
    apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https ca-certificates tzdata && \
    mv /usr/share/zoneinfo/Asia/Shanghai /Shanghai && \
    rm -rf /usr/share/zoneinfo && \
    mkdir -p /usr/share/zoneinfo/Asia && \
    mv /Shanghai /usr/share/zoneinfo/Asia/Shanghai && \
    ln -sTf /usr/share/zoneinfo/Asia/Shanghai /usr/share/zoneinfo/PRC && \
    ln -sTf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    \
    DEBIAN_FRONTEND="noninteractive" && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释" >> /etc/apt/sources.list && \
    echo "deb ${UBUNTU_MIRROR}/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src ${UBUNTU_MIRROR}/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb ${UBUNTU_MIRROR}/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src ${UBUNTU_MIRROR}/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb ${UBUNTU_MIRROR}/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src ${UBUNTU_MIRROR}/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb ${UBUNTU_MIRROR}/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src ${UBUNTU_MIRROR}/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb ${UBUNTU_MIRROR}/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src ${UBUNTU_MIRROR}/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    \
    rm -rf /var/lib/apt/lists/*

STOPSIGNAL SIGTERM

CMD ["/bin/bash"]
