FROM centos:latest
LABEL maintainer="YangJian <youken9980@163.com>"

ENV LANG="en_US.UTF-8"
ENV TZ="Asia/Shanghai"
VOLUME /tmp

RUN yum update -y && \
    yum install -y nano which tree curl wget telnet net-tools traceroute git subversion && \
    sed -i "/# User specific aliases and functions/a\alias ll='ls -la'" ~/.bashrc

CMD ["/bin/bash"]
