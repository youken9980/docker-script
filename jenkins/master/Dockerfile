FROM jenkins/jenkins:lts-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

USER root
RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache tzdata docker && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    \
    adduser jenkins root && \
    echo "jenkins:jenkins" | chpasswd && \
    sed -i "/  exec java -Duser.home=/i\  echo \"exec java -Duser.home=\"\$JENKINS_HOME\" \"\${java_opts_array[@]}\" -jar \${JENKINS_WAR} \"\${jenkins_opts_array[@]}\" \"\$@\"\"" /usr/local/bin/jenkins.sh

USER jenkins
WORKDIR /var/jenkins_home

STOPSIGNAL SIGTERM
