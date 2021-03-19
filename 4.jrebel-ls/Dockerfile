FROM youken9980/build-tools-openjdk8:latest as temp
LABEL maintainer="YangJian <youken9980@163.com>"

ENV GIT_URL="https://gitee.com/gsls200808/JrebelLicenseServerforJava.git"
ENV PROJ_SRC="/proj-src"

RUN git clone --depth=1 ${GIT_URL} ${PROJ_SRC} && \
    cd ${PROJ_SRC} && \
    mvn clean package -Dmaven.test.skip=true -U
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    cp ${PROJ_SRC}/target/JrebelBrainsLicenseServerforJava-$PROJ_VERSION.jar /service.jar


FROM youken9980/openjdk:8-jre-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

ENV JAVA_OPTS="-Dfile.encoding=UTF8 -Dsun.jnu.encoding=UTF8"

COPY --from=temp /service.jar /service.jar

EXPOSE 8080
STOPSIGNAL SIGTERM

CMD ["java", "-jar", "/service.jar", "-p", "8080"]
