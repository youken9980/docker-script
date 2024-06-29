FROM youken9980/build-tools-temurin8:repository as temp

ARG GITHUB_MIRROR=""
ENV GIT_URL="${GITHUB_MIRROR}https://github.com/MyCATApache/Mycat2.git"
ENV PROJ_SRC="/proj-src"

RUN git clone --depth=1 ${GIT_URL} ${PROJ_SRC}
WORKDIR ${PROJ_SRC}
RUN mvn -Dmaven.test.skip=true -U -T 4C clean compile package -pl mycat2 -am
RUN mv ${PROJ_SRC}/mycat2/src/main/resources /mycat && mkdir -p /mycat/logs
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    mv ${PROJ_SRC}/mycat2/target/mycat2-${PROJ_VERSION}-jar-with-dependencies.jar /mycat/mycat2.jar
RUN chmod -R 644 /mycat && \
    find /mycat -type d -exec chmod 755 {} \;


FROM youken9980/temurin:8-jre-jammy
LABEL maintainer="YangJian <youken9980@163.com>"

ENV MYCAT_HOME=/mycat

COPY --chown=root:root --from=temp $MYCAT_HOME $MYCAT_HOME
COPY entrypoint.sh /usr/local/bin/

EXPOSE 1984 8066

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
