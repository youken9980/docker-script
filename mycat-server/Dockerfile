FROM youken9980/maven:3-openjdk-8-slim as maven
LABEL maintainer="YangJian <youken9980@163.com>"

RUN GIT_URL="https://gitee.com/MycatOne/Mycat-Server.git" && \
    PROJ_SRC="/usr/local/src/proj-src" && \
    git clone $GIT_URL $PROJ_SRC && \
    cd $PROJ_SRC && \
    mvn clean package -Dmaven.test.skip=true -U && \
    PROJ_VERSION="$(xpath -q -e '//project/version/text()' pom.xml)" && \
    mv target/Mycat-server-$PROJ_VERSION-*-linux.tar.gz /mycat.tar.gz


FROM openjdk:8-jre-slim as mycat2
COPY --from=maven /mycat.tar.gz /mycat.tar.gz

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
    apt-get install --no-install-recommends -y procps && \
    tar -xvf /mycat.tar.gz -C /usr/local/ && rm /mycat.tar.gz && \
    mkdir -p /usr/local/mycat/logs && \
    sed -i 's|        <asyncRoot level="info" includeLocation="true">|        <asyncRoot level="debug" includeLocation="true">|g' /usr/local/mycat/conf/log4j2.xml && \
    touch /usr/local/bin/entrypoint.sh && \
    chmod 755 /usr/local/bin/entrypoint.sh && \
    echo "#!/bin/bash" >> /usr/local/bin/entrypoint.sh && \
    echo "mycat start" >> /usr/local/bin/entrypoint.sh && \
    echo "sleep 3s" >> /usr/local/bin/entrypoint.sh && \
    echo "tail -f --pid=\$(ps aux | grep "/usr/local/mycat" | grep "wrapper" | awk '{print \$2}') /usr/local/mycat/logs/wrapper.log | sed '/MyCAT[[:space:]]Server[[:space:]]startup[[:space:]]successfully/q'" >> /usr/local/bin/entrypoint.sh && \
    echo "tail -f /usr/local/mycat/logs/mycat.log" >> /usr/local/bin/entrypoint.sh

ENV PATH=$PATH:/usr/local/mycat/bin
EXPOSE 8066 9066 1984
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
