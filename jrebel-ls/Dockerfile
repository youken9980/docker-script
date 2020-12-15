FROM youken9980/maven3-openjdk8:latest as maven
LABEL maintainer="YangJian <youken9980@163.com>"

RUN GIT_URL="https://gitee.com/gsls200808/JrebelLicenseServerforJava.git" && \
    PROJ_SRC="/usr/local/src/proj-src" && \
    git clone --depth=1 $GIT_URL $PROJ_SRC && \
    cd $PROJ_SRC && \
    mvn clean package -Dmaven.test.skip=true -U && \
    PROJ_VERSION="$(xpath -q -e '//project/version/text()' pom.xml)" && \
    mv target/JrebelBrainsLicenseServerforJava-$PROJ_VERSION.jar /service.jar


FROM openjdk:8-jre-alpine as jrebel

ENV JAVA_OPTS="-Dfile.encoding=UTF8 -Dsun.jnu.encoding=UTF8"
ENV PORT 8080

RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache tzdata && \
    export TZ="Asia/Shanghai" && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY --from=maven /service.jar /service.jar
CMD java -jar /service.jar -p $PORT

STOPSIGNAL SIGTERM
