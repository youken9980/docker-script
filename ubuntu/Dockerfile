FROM ubuntu:latest
LABEL maintainer="YangJian <youken9980@163.com>"

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo Asia/Shanghai > /etc/timezone && \
    apt-get update && \
    apt-get install -y procps curl gnupg net-tools telnet inetutils-ping lsof locales && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs yarn

STOPSIGNAL SIGTERM

CMD ["/bin/bash"]
