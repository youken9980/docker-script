FROM youken9980/maven:3-openjdk-8-slim as maven
LABEL maintainer="YangJian <youken9980@163.com>"

RUN GIT_URL="https://gitee.com/MycatOne/Mycat-Server.git" && \
    PROJ_SRC="/usr/local/src/proj-src" && \
    git clone $GIT_URL $PROJ_SRC && \
    cd $PROJ_SRC && \
    mvn clean package -Dmaven.test.skip=true -U && \
    PROJ_VERSION="$(xpath -q -e '//project/version/text()' pom.xml)" && \
    mv target/Mycat-server-$PROJ_VERSION-*-linux.tar.gz /mycat.tar.gz && \
    tar -xvf /mycat.tar.gz -C / && rm /mycat.tar.gz && \
    mkdir -p /mycat/logs && \
    chmod -R 644 /mycat && \
    chmod 755 /mycat \
              /mycat/bin \
              /mycat/bin/* \
              /mycat/catlet \
              /mycat/conf \
              /mycat/conf/zkconf \
              /mycat/conf/zkdownload \
              /mycat/lib \
              /mycat/logs \
              && \
    sed -i 's|        <asyncRoot level="info" includeLocation="true">|        <asyncRoot level="debug" includeLocation="true">|g' /mycat/conf/log4j2.xml


FROM openjdk:8-jre-slim as mycat

RUN sed -i "s|# export LS_OPTIONS='--color=auto'|export LS_OPTIONS='--color=auto'|g" /root/.bashrc && \
    sed -i "s|# alias ls='ls \$LS_OPTIONS'|alias ls='ls \$LS_OPTIONS'|g" /root/.bashrc && \
    sed -i "s|# alias ll='ls \$LS_OPTIONS -l'|alias ll='ls \$LS_OPTIONS -l'|g" /root/.bashrc && \
    sed -i "s|# alias l='ls \$LS_OPTIONS -lA'|alias l='ls \$LS_OPTIONS -lA'|g" /root/.bashrc && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo Asia/Shanghai > /etc/timezone && \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y procps inetutils-ping telnet net-tools lsof

COPY --from=maven /mycat /usr/local/mycat

COPY realServerVip.sh /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

ENV PATH=$PATH:/usr/local/mycat/bin
EXPOSE 8066 9066 1984
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
