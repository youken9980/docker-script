FROM youken9980/build-tools-openjdk8:latest as temp

ENV GITHUB_MIRROR="https://github.com"
ENV GIT_URL="${GITHUB_MIRROR}/MyCATApache/Mycat2.git"
ENV PROJ_SRC="/proj-src"
ENV GIT_TAG="1.19-release"
ENV ORIGINAL_JAR="mycat2-1.19-jar-with-dependencies.jar"
ENV MYCAT2_INSTALL_ZIP="mycat2-install-template-1.21.zip"
ENV MYCAT2_INSTALL_URL="http://dl.mycat.org.cn/2.0/install-template/${MYCAT2_INSTALL_ZIP}"

RUN git clone ${GIT_URL} ${PROJ_SRC}
WORKDIR ${PROJ_SRC}
RUN git checkout ${GIT_TAG}
RUN mvn clean package -Dmaven.test.skip=true -U
WORKDIR /
RUN axel -n 8 ${MYCAT2_INSTALL_URL} && \
    unzip ${MYCAT2_INSTALL_ZIP} && \
    cp ${PROJ_SRC}/mycat2/target/${ORIGINAL_JAR} /mycat/lib/. && \
    chmod -R 644 /mycat && \
    chmod 755 /mycat \
              /mycat/bin \
              /mycat/conf \
              /mycat/lib \
              /mycat/logs \
              /mycat/bin/* \
              /mycat/conf/clusters \
              /mycat/conf/datasources \
              /mycat/conf/schemas \
              /mycat/conf/sequences \
              /mycat/conf/sql \
              /mycat/conf/sqlcaches \
              /mycat/conf/users


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
