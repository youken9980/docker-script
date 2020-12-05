FROM youken9980/maven3-openjdk8:latest as maven
LABEL maintainer="YangJian <youken9980@163.com>"

RUN GIT_URL="https://gitee.com/MycatOne/Mycat-Server.git" && \
    PROJ_SRC="/usr/local/src/proj-src" && \
    git clone $GIT_URL $PROJ_SRC && \
    cd $PROJ_SRC && \
    mvn clean package -Dmaven.test.skip=true -U && \
    PROJ_VERSION="$(xpath -q -e '//project/version/text()' pom.xml)" && \
    mv target/Mycat-server-$PROJ_VERSION-*-linux.tar.gz /mycat.tar.gz && \
    tar -xvf /mycat.tar.gz -C / && rm /mycat.tar.gz && \
    mkdir -p /mycat/logs && \
    chmod -R 644 /mycat && \
    chmod 755 /mycat \
              /mycat/bin \
              /mycat/bin/* \
              /mycat/catlet \
              /mycat/conf \
              /mycat/conf/zkconf \
              /mycat/conf/zkdownload \
              /mycat/lib \
              /mycat/logs \
              && \
    sed -i 's|        <asyncRoot level="info" includeLocation="true">|        <asyncRoot level="debug" includeLocation="true">|g' /mycat/conf/log4j2.xml


FROM youken9980/openjdk8-jre-alpine:latest

ENV KEEPALIVED_INTERFACE="eth0"
ENV KEEPALIVED_STATE="BACKUP"
ENV KEEPALIVED_ROUTER_ID="100"
ENV KEEPALIVED_PRIORITY="150"
ENV KEEPALIVED_PASSWORD="d0cker"
ENV KEEPALIVED_VIRTUAL_IP="172.18.0.100"
ENV PATH=$PATH:/usr/local/mycat/bin

COPY --from=maven /mycat /usr/local/mycat
COPY realServerVip.sh /usr/local/bin/
COPY check_service.sh /usr/local/bin/
COPY notify.sh /usr/local/bin/
COPY keepalived.conf /etc/keepalived/
COPY entrypoint.sh /usr/local/bin/

RUN apk add --no-cache which procps busybox-extras wget ipvsadm keepalived

EXPOSE 8066 9066 1984
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
