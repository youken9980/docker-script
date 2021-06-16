FROM youken9980/build-tools-openjdk8:latest as temp
LABEL maintainer="YangJian <youken9980@163.com>"

ENV GITHUB_MIRROR="https://hub.fastgit.org"
ENV GIT_URL="${GITHUB_MIRROR}/MyCATApache/Mycat2.git"
ENV PROJ_SRC="/proj-src"
ENV GIT_TAG="v1.12-2020-7-16"

RUN git clone ${GIT_URL} ${PROJ_SRC} && \
    cd ${PROJ_SRC} && \
    git checkout ${GIT_TAG} && \
    mvn clean package -Dmaven.test.skip=true -U
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    cp ${PROJ_SRC}/mycat2/target/mycat2-$PROJ_VERSION.tar.gz /mycat.tar.gz && \
    tar -xvf /mycat.tar.gz -C / && \
    mkdir -p /mycat/logs && \
    rm -rf /mycat/example && \
    chmod -R 644 /mycat && \
    chmod 755 /mycat \
              /mycat/bin \
              /mycat/bin/* \
              /mycat/conf \
              /mycat/conf/sql \
              /mycat/lib \
              /mycat/logs


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

EXPOSE 1984 8066

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
