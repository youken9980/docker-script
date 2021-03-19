FROM alpine:3
LABEL maintainer="YangJian <youken9980@163.com>"

ENV TZ="Asia/Shanghai"

RUN sed -i "s|dl-cdn.alpinelinux.org|mirrors.sjtug.sjtu.edu.cn|g" /etc/apk/repositories && \
    apk --update --no-cache add tzdata ca-certificates axel && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    \
    GLIBC_VERSION="2.33-r0" && \
    axel -n 32 -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    axel -n 32 -o /glibc-${GLIBC_VERSION}.apk https://hub.fastgit.org/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    apk add glibc-${GLIBC_VERSION}.apk && \
    rm -rf glibc-${GLIBC_VERSION}.apk

STOPSIGNAL SIGTERM
