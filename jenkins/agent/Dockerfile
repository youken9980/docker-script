FROM jenkins/inbound-agent:alpine
LABEL maintainer="YangJian <youken9980@163.com>"

ENV MAVEN_VERSION="3.6.3"
ENV MAVEN_REPO="/app/maven-repository"
ENV MAVEN_DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.zip"
ENV MAVEN_HOME="/app/apache-maven-$MAVEN_VERSION"
ENV MAVEN_REPOSITORY="$MAVEN_REPO"
ENV M2_REPO="$MAVEN_REPO"

ENV GRADLE_VERSION="6.7.1"
ENV GRADLE_REPO="/app/gradle-repository"
ENV GRADLE_DOWNLOAD_URL="https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip"
ENV GRADLE_HOME="/app/gradle-$GRADLE_VERSION"
ENV GRADLE_USER_HOME="$GRADLE_REPO"

ENV PATH=".:$PATH:$MAVEN_HOME/bin:$GRADLE_HOME/bin"

USER root
RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache tzdata git subversion unzip docker && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    \
    adduser jenkins root && \
    echo "jenkins:jenkins" | chpasswd && \
    \
    mkdir -p /app && \
    cd /app && \
    wget -c $MAVEN_DOWNLOAD_URL && \
    wget -c $GRADLE_DOWNLOAD_URL && \
    unzip "*.zip" && \
    rm *.zip && \
    apk del unzip && \
    sed -i "/  <!-- localRepository/i\  <localRepository>$MAVEN_REPO</localRepository>" $MAVEN_HOME/conf/settings.xml && \
    sed -i "/    <!-- mirror/i\    <mirror>" $MAVEN_HOME/conf/settings.xml && \
    sed -i "/    <!-- mirror/i\        <id>aliyunmaven</id>" $MAVEN_HOME/conf/settings.xml && \
    sed -i "/    <!-- mirror/i\        <mirrorOf>*</mirrorOf>" $MAVEN_HOME/conf/settings.xml && \
    sed -i "/    <!-- mirror/i\        <name>阿里云公共仓库</name>" $MAVEN_HOME/conf/settings.xml && \
    sed -i "/    <!-- mirror/i\        <url>https://maven.aliyun.com/repository/public</url>" $MAVEN_HOME/conf/settings.xml && \
    sed -i "/    <!-- mirror/i\    </mirror>" $MAVEN_HOME/conf/settings.xml
RUN mkdir -p $MAVEN_REPO && chown jenkins:jenkins $MAVEN_REPO && \
    mkdir -p $GRADLE_REPO && chown jenkins:jenkins $GRADLE_REPO

USER jenkins
WORKDIR /home/jenkins

STOPSIGNAL SIGTERM

ENTRYPOINT ["jenkins-agent"]
