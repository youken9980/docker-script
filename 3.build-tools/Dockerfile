FROM youken9980/alpine:latest as temp
LABEL maintainer="YangJian <youken9980@163.com>"

ENV MAVEN_VERSION="3.6.3"
ENV MAVEN_DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip"
ENV MAVEN_HOME="/usr/local/maven-${MAVEN_VERSION}"
ENV MAVEN_REPO="/usr/local/maven-repository"
ENV MAVEN_REPOSITORY="${MAVEN_REPO}"
ENV M2_REPO="${MAVEN_REPO}"

ENV GRADLE_VERSION="6.7.1"
ENV GRADLE_DOWNLOAD_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
ENV GRADLE_HOME="/usr/local/gradle-${GRADLE_VERSION}"
ENV GRADLE_REPO="/usr/local/gradle-repository"
ENV GRADLE_USER_HOME="${GRADLE_REPO}"

ENV PATH=".:${PATH}:${MAVEN_HOME}/bin:${GRADLE_HOME}/bin"

# RUN wget -c ${MAVEN_DOWNLOAD_URL}
# RUN wget -c ${GRADLE_DOWNLOAD_URL}
COPY *.zip /
RUN mkdir -p ${MAVEN_REPO} ${GRADLE_REPO} && \
    apk add zip && unzip "*.zip" && \
    mv /apache-maven-${MAVEN_VERSION} ${MAVEN_HOME} && \
    sed -i "/  <!-- localRepository/i\  <localRepository>${MAVEN_REPO}</localRepository>" ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\    <mirror>' ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <id>aliyunmaven</id>' ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <mirrorOf>*</mirrorOf>' ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <name>阿里云公共仓库</name>' ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\        <url>https://maven.aliyun.com/repository/public</url>' ${MAVEN_HOME}/conf/settings.xml && \
    sed -i '/    <!-- mirror/i\    </mirror>' ${MAVEN_HOME}/conf/settings.xml && \
    mv /gradle-${GRADLE_VERSION} ${GRADLE_HOME}


FROM youken9980/openjdk:8-jdk-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

RUN apk add --no-cache git subversion perl-xml-xpath

ENV MAVEN_VERSION="3.6.3"
ENV MAVEN_HOME="/usr/local/maven-${MAVEN_VERSION}"
ENV MAVEN_REPO="/usr/local/maven-repository"
ENV MAVEN_REPOSITORY="${MAVEN_REPO}"
ENV M2_REPO="${MAVEN_REPO}"

ENV GRADLE_VERSION="6.7.1"
ENV GRADLE_HOME="/usr/local/gradle-${GRADLE_VERSION}"
ENV GRADLE_REPO="/usr/local/gradle-repository"
ENV GRADLE_USER_HOME="${GRADLE_REPO}"

ENV PATH="${PATH}:${MAVEN_HOME}/bin:${GRADLE_HOME}/bin"

COPY --chown=root:root --from=temp ${MAVEN_HOME} ${MAVEN_HOME}
COPY --chown=root:root --from=temp ${MAVEN_REPO} ${MAVEN_REPO}
COPY --chown=root:root --from=temp ${GRADLE_HOME} ${GRADLE_HOME}
COPY --chown=root:root --from=temp ${GRADLE_REPO} ${GRADLE_REPO}

STOPSIGNAL SIGTERM
