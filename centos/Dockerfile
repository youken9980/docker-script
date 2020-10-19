FROM centos:8
LABEL maintainer="YangJian <youken9980@163.com>"

ENV LANG="en_US.UTF-8"
ENV TZ="Asia/Shanghai"
VOLUME /tmp

RUN sed -i "/# User specific aliases and functions/a\alias ll='ls -la'" ~/.bashrc && \
    mv /etc/yum.repos.d /etc/yum.repos.d.bak && \
    mkdir -p /etc/yum.repos.d && \
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    yum makecache && \
    yum update -y && \
    yum install -y nano which tree curl wget telnet net-tools traceroute git subversion

CMD ["/bin/bash"]
