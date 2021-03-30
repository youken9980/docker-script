FROM youken9980/alpine:3 as maven

ENV MAVEN_VERSION="3.6.3"
ENV MAVEN_DOWNLOAD_URL="https://mirrors.bfsu.edu.cn/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
ENV MAVEN_HOME="/usr/local/maven-${MAVEN_VERSION}"
ENV MAVEN_REPO="/usr/local/maven-repository"

RUN axel -n 32 ${MAVEN_DOWNLOAD_URL} && \
    mkdir -p ${MAVEN_HOME} && \
    tar zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz --strip 1 -C ${MAVEN_HOME} && \
    sed -i "/  <!-- localRepository/i\  <localRepository>${MAVEN_REPO}</localRepository>" ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\    <mirror>' ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <id>aliyunmaven</id>' ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <mirrorOf>*</mirrorOf>' ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <name>阿里云公共仓库</name>' ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <url>https://maven.aliyun.com/repository/public</url>' ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\    </mirror>' ${MAVEN_HOME}/conf/settings.xml


FROM youken9980/alpine:3 as gradle

ENV GRADLE_VERSION="6.8.3"
ENV GRADLE_DOWNLOAD_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
ENV GRADLE_HOME="/usr/local/gradle-${GRADLE_VERSION}"

RUN axel -n 32 ${GRADLE_DOWNLOAD_URL} && \
    apk --update --no-cache add zip && unzip "*.zip" && \
    mv /gradle-${GRADLE_VERSION} ${GRADLE_HOME}


FROM youken9980/openjdk:8-jdk-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

ENV MAVEN_VERSION="3.6.3"
ENV MAVEN_HOME="/usr/local/maven-${MAVEN_VERSION}"
ENV MAVEN_REPO="/usr/local/maven-repository"
ENV MAVEN_REPOSITORY="${MAVEN_REPO}"
ENV M2_REPO="${MAVEN_REPO}"

ENV GRADLE_VERSION="6.8.3"
ENV GRADLE_HOME="/usr/local/gradle-${GRADLE_VERSION}"
ENV GRADLE_REPO="/usr/local/gradle-repository"
ENV GRADLE_USER_HOME="${GRADLE_REPO}"

ENV PATH="${PATH}:${MAVEN_HOME}/bin:${GRADLE_HOME}/bin"

COPY --chown=root:root --from=maven ${MAVEN_HOME} ${MAVEN_HOME}
COPY --chown=root:root --from=gradle ${GRADLE_HOME} ${GRADLE_HOME}

RUN apk --update --no-cache add git subversion perl-xml-xpath && \
    mkdir -p ${MAVEN_REPO} ${GRADLE_REPO} && \
    rm -rf /var/cache/apk/*.*

STOPSIGNAL SIGTERM

CMD [ "/bin/sh" ]
