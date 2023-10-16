FROM youken9980/ubuntu:jammy as temp

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget unzip

# http://dl.mycat.org.cn/2.0/install-template/mycat2-install-template-1.21.zip
# http://dl.mycat.org.cn/2.0/1.22-release/mycat2-1.22-release-jar-with-dependencies.jar
RUN MYCAT_INSTALL_VERSION="1.21" && \
    MYCAT_JAR_VERSION="1.22" && \
    MYCAT_INSTALL_URL="http://dl.mycat.org.cn/2.0/install-template/mycat2-install-template-${MYCAT_INSTALL_VERSION}.zip" && \
    MYCAT_JAR_URL="http://dl.mycat.org.cn/2.0/${MYCAT_JAR_VERSION}-release/mycat2-${MYCAT_JAR_VERSION}-release-jar-with-dependencies.jar" && \
    wget -O mycat2-install.zip ${MYCAT_INSTALL_URL} && \
    unzip mycat2-install.zip && \
    rm -f mycat2-install.zip && \
    wget -O /mycat/lib/mycat2-${MYCAT_JAR_VERSION}-release-jar-with-dependencies.jar ${MYCAT_JAR_URL} && \
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


FROM youken9980/temurin:8-jre-jammy
LABEL maintainer="YangJian <youken9980@163.com>"

ENV PATH=".:$PATH:/mycat/bin"

COPY --chown=root:root --from=temp /mycat /mycat
COPY entrypoint.sh /usr/local/bin/

EXPOSE 1984 8066

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
