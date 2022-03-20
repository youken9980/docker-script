FROM adoptopenjdk:16-jre
LABEL maintainer="YangJian <youken9980@163.com>"

ENV SHELL="/bin/bash"
ENV TZ="Asia/Shanghai"

RUN set -eux && \
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
    UBUNTU_MIRROR="https://mirrors.tuna.tsinghua.edu.cn" && \
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
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && \
    apt-get install --no-install-recommends -y axel && \
    mkdir /papermc && cd /papermc && \
    PAPERMC_VERSION="1.17.1" && \
    PAPERMC_BUILD="157" && \
    axel -n 32 -o papermc.jar https://papermc.io/api/v2/projects/paper/versions/${PAPERMC_VERSION}/builds/${PAPERMC_BUILD}/downloads/paper-${PAPERMC_VERSION}-${PAPERMC_BUILD}.jar && \
    java -jar papermc.jar && \
    sed -i 's|eula=false|eula=true|g' eula.txt && \
    sed -i 's|online-mode=true|online-mode=false|g' server.properties

# server.properties
# gamemode=survival  //游戏模式 0=生存 1=创造 2=冒险 3=旁观
# difficulty=easy  //难度0=和平 1=简单 2=普通 3=困难
# max-players=20  //服务器最大玩家数限制
# server-port=25565  //服务器端口
# online-mode=true  //在线（正版）验证[默认启用]
# pvp=true

EXPOSE 25565

WORKDIR /papermc
CMD ["java", "-Xms2G", "-Xmx2G", "-jar", "/papermc/papermc.jar", "--nogui"]
