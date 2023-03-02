FROM ubuntu:jammy
LABEL maintainer="YangJian <youken9980@163.com>"

ENV SHELL="/bin/bash"
ENV TZ="Asia/Shanghai"

RUN set -eux && \
    UBUNTU_MIRROR="https://mirrors.bfsu.edu.cn" && \
    \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" && \
    apt-get install --no-install-recommends -y apt-transport-https ca-certificates tzdata fontconfig locales && \
    mv /usr/share/zoneinfo/Asia/Shanghai /Shanghai && \
    rm -rf /usr/share/zoneinfo && \
    mkdir -p /usr/share/zoneinfo/Asia && \
    mv /Shanghai /usr/share/zoneinfo/Asia/Shanghai && \
    ln -sTf /usr/share/zoneinfo/Asia/Shanghai /usr/share/zoneinfo/PRC && \
    ln -sTf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释" >> /etc/apt/sources.list && \
    echo "deb ${UBUNTU_MIRROR}/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src ${UBUNTU_MIRROR}/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb ${UBUNTU_MIRROR}/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src ${UBUNTU_MIRROR}/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb ${UBUNTU_MIRROR}/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src ${UBUNTU_MIRROR}/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb ${UBUNTU_MIRROR}/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src ${UBUNTU_MIRROR}/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# 预发布软件源，不建议启用" >> /etc/apt/sources.list && \
    echo "# deb ${UBUNTU_MIRROR}/ubuntu/ jammy-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src ${UBUNTU_MIRROR}/ubuntu/ jammy-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    \
    rm -rf /var/lib/apt/lists/* \
           /var/cache/* \
           /tmp/*

STOPSIGNAL SIGTERM

CMD ["/bin/bash"]
