FROM youken9980/ubuntu:jammy as temp

ENV JAVA_HOME="/opt/java/openjdk"

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget unzip

# http://dl.mycat.org.cn/1.6.7.6/20220524101549/Mycat-server-1.6.7.6-release-20220524173810-linux.tar.gz
RUN MYCAT_VERSION="1.6.7.6" && \
    MYCAT_URL="http://dl.mycat.org.cn/${MYCAT_VERSION}/20220524101549/Mycat-server-${MYCAT_VERSION}-release-20220524173810-linux.tar.gz" && \
    wget -O mycat.tar.gz ${MYCAT_URL} && \
    mkdir -p /mycat && \
    tar -zxvf mycat.tar.gz -C /mycat --strip-components=1 --no-same-owner && \
    rm -f mycat.tar.gz && \
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


FROM youken9980/openjdk:8-jre-jammy
LABEL maintainer="YangJian <youken9980@163.com>"

ENV PATH=".:$PATH:/mycat/bin"

COPY --chown=root:root --from=temp /mycat /mycat
COPY entrypoint.sh /usr/local/bin/

EXPOSE 1984 8066 9066

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
