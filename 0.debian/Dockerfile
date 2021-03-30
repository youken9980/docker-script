FROM debian:buster-slim
LABEL maintainer="YangJian <youken9980@163.com>"

ENV SHELL="/bin/bash"
ENV TZ="Asia/Shanghai"
ENV DEBIAN_MIRROR="https://mirrors.163.com"

RUN set -eux && \
    \
    apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    \
    mv /usr/share/zoneinfo/PRC /PRC && \
    rm -rf /usr/share/zoneinfo && \
    mkdir -p /usr/share/zoneinfo/Asia && \
    mv /PRC /usr/share/zoneinfo/PRC && \
    ln -sTf /usr/share/zoneinfo/PRC /usr/share/zoneinfo/Asia/Shanghai && \
    ln -sTf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    \
    sed -i "s|# export LS_OPTIONS='--color=auto'|export LS_OPTIONS='--color=auto'|g" /root/.bashrc && \
    sed -i 's|# eval "`dircolors`"|eval "`dircolors`"|g' /root/.bashrc && \
    sed -i "s|# alias ls='ls \$LS_OPTIONS'|alias ls='ls \$LS_OPTIONS'|g" /root/.bashrc && \
    sed -i "s|# alias ll='ls \$LS_OPTIONS -l'|alias ll='ls \$LS_OPTIONS -la'|g" /root/.bashrc && \
    sed -i "s|# alias l='ls \$LS_OPTIONS -lA'|alias l='ls \$LS_OPTIONS -lA'|g" /root/.bashrc && \
    \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb ${DEBIAN_MIRROR}/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src ${DEBIAN_MIRROR}/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb ${DEBIAN_MIRROR}/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb-src ${DEBIAN_MIRROR}/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb ${DEBIAN_MIRROR}/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src ${DEBIAN_MIRROR}/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb ${DEBIAN_MIRROR}/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src ${DEBIAN_MIRROR}/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list && \
    \
    rm -rf /var/lib/apt/lists/*

STOPSIGNAL SIGTERM

CMD ["/bin/bash"]
