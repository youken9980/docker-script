FROM youken9980/mycat-server:latest
LABEL maintainer="YangJian <youken9980@163.com>"

ENV KEEPALIVED_INTERFACE="eth0"
ENV KEEPALIVED_STATE="BACKUP"
ENV KEEPALIVED_ROUTER_ID="100"
ENV KEEPALIVED_PRIORITY="150"
ENV KEEPALIVED_PASSWORD="d0cker"
ENV KEEPALIVED_VIRTUAL_IP="172.18.0.100"

RUN apt-get install --no-install-recommends -y rsyslog ipvsadm keepalived

ADD check_service.sh /usr/local/bin/
ADD notify.sh /usr/local/bin/
ADD keepalived.conf /etc/keepalived/
ADD entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
