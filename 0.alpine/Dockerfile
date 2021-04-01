FROM alpine:3
LABEL maintainer="YangJian <youken9980@163.com>"

ENV TZ="Asia/Shanghai"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV ALPINE_MIRROR="mirrors.sjtug.sjtu.edu.cn"
ENV GITHUB_MIRROR="https://github.wuyanzheshui.workers.dev"
# https://hub.fastgit.org
# https://github.com.cnpmjs.org
# https://github.wuyanzheshui.workers.dev
# https://gitclone.com/github.com
# http://toolwa.com/github

RUN sed -i "s|dl-cdn.alpinelinux.org|${ALPINE_MIRROR}|g" /etc/apk/repositories && \
    apk --update --no-cache add tzdata ca-certificates axel && \
    mv /usr/share/zoneinfo/Asia/Shanghai /Shanghai && \
    rm -rf /usr/share/zoneinfo && \
    mkdir -p /usr/share/zoneinfo/Asia && \
    mv /Shanghai /usr/share/zoneinfo/Asia/. && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    update-ca-certificates && \
    \
    rm -rf /var/cache/apk/*.*

STOPSIGNAL SIGTERM

CMD [ "/bin/sh" ]
