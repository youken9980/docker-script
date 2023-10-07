FROM youken9980/alpine:3 as maven

RUN apk --update --no-cache add zip

ENV MAVEN_VERSION="3.9.5"
ENV MAVEN_DOWNLOAD_URL="https://mirrors.bfsu.edu.cn/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
ENV MAVEN_HOME="/usr/local/maven-${MAVEN_VERSION}"
ENV MAVEN_REPO="/usr/local/maven-repository"

RUN axel -n 8 -o maven.tar.gz ${MAVEN_DOWNLOAD_URL} && \
    mkdir -p ${MAVEN_HOME} && \
    tar -zxvf maven.tar.gz -C ${MAVEN_HOME} --strip-components=1 --no-same-owner

COPY settings.xml ${MAVEN_HOME}/conf/settings.xml

# RUN sed -i "/  <!-- localRepository/i\  <localRepository>${MAVEN_REPO}</localRepository>" ${MAVEN_HOME}/conf/settings.xml && \
#     sed -i '/    <!-- mirror/i\    <mirror>' ${MAVEN_HOME}/conf/settings.xml && \
#     sed -i '/    <!-- mirror/i\        <id>aliyunmaven</id>' ${MAVEN_HOME}/conf/settings.xml && \
#     sed -i '/    <!-- mirror/i\        <mirrorOf>*</mirrorOf>' ${MAVEN_HOME}/conf/settings.xml && \
#     sed -i '/    <!-- mirror/i\        <name>阿里云公共仓库</name>' ${MAVEN_HOME}/conf/settings.xml && \
#     sed -i '/    <!-- mirror/i\        <url>https://maven.aliyun.com/repository/public</url>' ${MAVEN_HOME}/conf/settings.xml && \
#     sed -i '/    <!-- mirror/i\    </mirror>' ${MAVEN_HOME}/conf/settings.xml


FROM youken9980/alpine:3 as gradle

RUN apk --update --no-cache add zip

ENV GRADLE_VERSION="8.4"
ENV GRADLE_DOWNLOAD_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
ENV GRADLE_HOME="/usr/local/gradle-${GRADLE_VERSION}"

RUN axel -n 8 -o gradle.zip ${GRADLE_DOWNLOAD_URL} && \
    unzip gradle.zip && \
    mv /gradle-${GRADLE_VERSION} ${GRADLE_HOME}


FROM youken9980/openjdk:8-jdk-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

ENV MAVEN_VERSION="3.9.5"
ENV MAVEN_HOME="/usr/local/maven-${MAVEN_VERSION}"
ENV MAVEN_REPO="/usr/local/maven-repository"
ENV MAVEN_REPOSITORY="${MAVEN_REPO}"
ENV M2_REPO="${MAVEN_REPO}"

ENV GRADLE_VERSION="8.4"
ENV GRADLE_HOME="/usr/local/gradle-${GRADLE_VERSION}"
ENV GRADLE_REPO="/usr/local/gradle-repository"
ENV GRADLE_USER_HOME="${GRADLE_REPO}"

ENV PATH="${PATH}:${MAVEN_HOME}/bin:${GRADLE_HOME}/bin"

RUN apk --update --no-cache add git subversion perl-xml-xpath && \
    mkdir -p ${MAVEN_REPO} ${GRADLE_REPO} && \
    GITHUB_MIRROR="https://ghps.cc/https://github.com" && \
    GITHUBUSERCONTENT_MIRROR="https://raw.staticdn.net" && \
    git config --global url."${GITHUB_MIRROR}".insteadof "https://github.com" && \
    git config --global url."${GITHUBUSERCONTENT_MIRROR}".insteadof "https://raw.githubusercontent.com" && \
    \
    rm -rf /var/cache/apk/*.*

COPY --chown=root:root --from=maven ${MAVEN_HOME} ${MAVEN_HOME}
COPY --chown=root:root --from=gradle ${GRADLE_HOME} ${GRADLE_HOME}

STOPSIGNAL SIGTERM

CMD [ "/bin/sh" ]
