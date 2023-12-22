FROM alpine:3
LABEL maintainer="YangJian <youken9980@163.com>"

# dl-cdn.alpinelinux.org
# mirrors.sjtug.sjtu.edu.cn
# mirrors.tuna.tsinghua.edu.cn
# mirrors.aliyun.com

ENV TZ="Asia/Shanghai"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"

RUN set -eux && \
    ALPINE_MIRROR="mirrors.sjtug.sjtu.edu.cn" && \
    \
    sed -i "s|dl-cdn.alpinelinux.org|${ALPINE_MIRROR}|g" /etc/apk/repositories && \
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
