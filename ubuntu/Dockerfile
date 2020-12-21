FROM ubuntu:20.04
LABEL maintainer="YangJian <youken9980@163.com>"

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo Asia/Shanghai > /etc/timezone && \
    apt-get update && \
    apt-get install -y procps curl gnupg net-tools telnet inetutils-ping lsof locales

STOPSIGNAL SIGTERM

CMD ["/bin/bash"]
