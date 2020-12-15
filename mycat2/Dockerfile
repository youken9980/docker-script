FROM youken9980/maven3-openjdk8:latest as maven
LABEL maintainer="YangJian <youken9980@163.com>"

RUN GIT_URL="https://gitee.com/MycatOne/Mycat2.git" && \
    PROJ_SRC="/usr/local/src/proj-src" && \
    git clone $GIT_URL $PROJ_SRC && \
    cd $PROJ_SRC && \
    mvn clean package -Dmaven.test.skip=true -U && \
    PROJ_VERSION="$(xpath -q -e '//project/version/text()' pom.xml)" && \
    mv mycat2/target/mycat2-$PROJ_VERSION.tar.gz /mycat.tar.gz


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

COPY --from=maven /mycat.tar.gz /mycat.tar.gz
RUN tar -xvf /mycat.tar.gz -C /usr/local/ && rm /mycat.tar.gz && \
    mkdir -p /usr/local/mycat/logs && \
    \
    touch /usr/local/bin/entrypoint.sh && \
    chmod 755 /usr/local/bin/entrypoint.sh && \
    echo "#!/bin/bash" >> /usr/local/bin/entrypoint.sh && \
    echo "mycat start" >> /usr/local/bin/entrypoint.sh && \
    echo "sleep 1s" >> /usr/local/bin/entrypoint.sh && \
    \
    echo "tail -f /usr/local/mycat/logs/mycat.log" >> /usr/local/bin/entrypoint.sh

ENV PATH=$PATH:/usr/local/mycat/bin

EXPOSE 8066 9066 1984

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
