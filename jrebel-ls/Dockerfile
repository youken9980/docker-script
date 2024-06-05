FROM youken9980/build-tools-temurin8:repository as temp

ARG GITHUB_MIRROR=""
ENV GIT_URL="${GITHUB_MIRROR}https://github.com/NipGeihou/JrebelLicenseServerforJava.git"
ENV PROJ_SRC="/proj-src"

RUN git clone --depth=1 ${GIT_URL} ${PROJ_SRC}
WORKDIR ${PROJ_SRC}
RUN mvn clean package -Dmaven.test.skip=true -U
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    cp ${PROJ_SRC}/target/JrebelBrainsLicenseServerforJava-${PROJ_VERSION}-jar-with-dependencies.jar /service.jar


FROM youken9980/temurin:8-jre-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

COPY --from=temp /service.jar /service.jar

ENV SERVER_PORT 8080
EXPOSE ${SERVER_PORT}

STOPSIGNAL SIGTERM

CMD java -Djava.security.egd=file:/dev/./urandom -Dfile.encoding=UTF8 -Dsun.jnu.encoding=UTF8 -jar /service.jar -p ${SERVER_PORT}
