FROM debian:buster-slim
LABEL maintainer="YangJian <youken9980@163.com>"

ENV SHELL="/bin/bash"
ENV LANG="en_US.UTF-8"
ENV TZ="Asia/Shanghai"
VOLUME /tmp

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    sed -i "s|# export LS_OPTIONS='--color=auto'|export LS_OPTIONS='--color=auto'|g" /root/.bashrc && \
    sed -i 's|# eval "`dircolors`"|eval "`dircolors`"|g' /root/.bashrc && \
    sed -i "s|# alias ls='ls \$LS_OPTIONS'|alias ls='ls \$LS_OPTIONS'|g" /root/.bashrc && \
    sed -i "s|# alias ll='ls \$LS_OPTIONS -l'|alias ll='ls \$LS_OPTIONS -la'|g" /root/.bashrc && \
    sed -i "s|# alias l='ls \$LS_OPTIONS -lA'|alias l='ls \$LS_OPTIONS -lA'|g" /root/.bashrc && \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list

STOPSIGNAL SIGTERM

CMD ["/bin/bash"]
