FROM youken9980/build-tools-openjdk8:latest as temp
LABEL maintainer="YangJian <youken9980@163.com>"

ENV GITHUB_MIRROR="https://github.com.cnpmjs.org"
ENV GIT_URL="${GITHUB_MIRROR}/MyCATApache/Mycat-Server.git"
ENV PROJ_SRC="/proj-src"

RUN git clone ${GIT_URL} ${PROJ_SRC} && \
    cd ${PROJ_SRC} && \
    mvn clean package -Dmaven.test.skip=true -U
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    cp ${PROJ_SRC}/target/Mycat-server-$PROJ_VERSION-*-linux.tar.gz /mycat.tar.gz && \
    tar -xvf /mycat.tar.gz -C / && \
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


FROM youken9980/openjdk:8-jre-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

ENV KEEPALIVED_INTERFACE="eth0"
ENV KEEPALIVED_STATE="BACKUP"
ENV KEEPALIVED_ROUTER_ID="100"
ENV KEEPALIVED_PRIORITY="150"
ENV KEEPALIVED_PASSWORD="d0cker"
ENV KEEPALIVED_VIRTUAL_IP="172.18.0.100"
ENV PATH=$PATH:/usr/local/mycat/bin

RUN apk --update --no-cache add which procps busybox-extras ipvsadm keepalived && \
    rm -rf /var/cache/apk/*.*

COPY --from=temp /mycat /usr/local/mycat

COPY realServerVip.sh /usr/local/bin/
COPY notify.sh /usr/local/bin/
COPY keepalived.conf /etc/keepalived/
COPY check_service.sh /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

EXPOSE 1984 8066 9066

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
