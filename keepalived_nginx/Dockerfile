FROM alpine:latest
LABEL maintainer="YangJian <youken9980@163.com>"

ENV KEEPALIVED_INTERFACE="eth0"
ENV KEEPALIVED_STATE="BACKUP"
ENV KEEPALIVED_ROUTER_ID="100"
ENV KEEPALIVED_PRIORITY="150"
ENV KEEPALIVED_PASSWORD="d0cker"
ENV KEEPALIVED_VIRTUAL_IP="172.18.0.100"

VOLUME ["/sys/fs/cgroup"]

ADD entrypoint.sh /usr/local/bin/
ADD check_nginx.sh /usr/local/bin/
ADD notify.sh /usr/local/bin/
ADD default.conf /etc/nginx/conf.d/
ADD keepalived.conf /etc/keepalived/

RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories && \
    apk update && \
    apk add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk add --no-cache which procps busybox-extras wget openrc keepalived nginx && \
    rm -rf /var/cache/apk/* /tmp/* && \
    mkdir -p /run/openrc && touch /run/openrc/softlevel && \
    sed -i '/error_log/a\pid /etc/nginx/nginx.pid;' /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
