FROM youken9980/build-tools-temurin8:repository as temp

ARG GITHUB_MIRROR=""
ENV GIT_URL="${GITHUB_MIRROR}https://github.com/MyCATApache/Mycat-Server.git"
ENV PROJ_SRC="/proj-src"

RUN git clone --depth=1 ${GIT_URL} ${PROJ_SRC}
WORKDIR ${PROJ_SRC}
RUN mvn -Dmaven.test.skip=true -U -T 4C clean compile package
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    mv ${PROJ_SRC}/target/Mycat-server-${PROJ_VERSION}-*-linux.tar.gz /mycat.tar.gz
WORKDIR /
RUN mkdir -p /mycat/logs && \
    touch /mycat/logs/mycat.log && \
    tar -zxvf /mycat.tar.gz -C /mycat --strip-components=1 --no-same-owner && \
    rm -f /mycat.tar.gz && \
    chmod -R 644 /mycat && \
    find /mycat -type d -exec chmod 755 {} \; && \
    chmod -R 755 /mycat/bin/* && \
    sed -i 's|        <asyncRoot level="info" includeLocation="true">|        <asyncRoot level="debug" includeLocation="true">|g' /mycat/conf/log4j2.xml


FROM youken9980/temurin:8-jre-jammy
LABEL maintainer="YangJian <youken9980@163.com>"

ENV MYCAT_HOME=/mycat
ENV PATH=".:$PATH:$MYCAT_HOME/bin"

COPY --chown=root:root --from=temp $MYCAT_HOME $MYCAT_HOME
COPY entrypoint.sh /usr/local/bin/

EXPOSE 1984 8066 9066

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
