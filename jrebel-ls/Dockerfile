FROM youken9980/build-tools-temurin8:latest as temp

ENV GIT_URL="https://gitee.com/nism/jrebel-server.git"
ENV PROJ_SRC="/proj-src"

RUN git clone --depth=1 ${GIT_URL} ${PROJ_SRC}
WORKDIR ${PROJ_SRC}
RUN mvn clean package -Dmaven.test.skip=true -U
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    cp ${PROJ_SRC}/target/JrebelServer.jar /service.jar


FROM youken9980/temurin:8-jre-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

COPY --from=temp /service.jar /service.jar

EXPOSE 8080

STOPSIGNAL SIGTERM

CMD ["java", "-Dfile.encoding=UTF8", "-Dsun.jnu.encoding=UTF8", "-jar", "/service.jar", "-p", "8080"]
