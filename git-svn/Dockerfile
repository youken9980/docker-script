FROM youken9980/alpine:3
LABEL maintainer="YangJian <youken9980@163.com>"

ENV GITHUB_MIRROR="https://hub.fastgit.org"
ENV GIT_USER_NAME="user.name"
ENV GIT_USER_EMAIL="user.email"

RUN set -eux && \
    apk --update --no-cache add git subversion git-svn openssh-keygen && \
    \
    rm -rf /var/cache/apk/*.*

COPY entrypoint.sh /entrypoint.sh
COPY sshkeygen.sh /sshkeygen.sh

WORKDIR /root

ENTRYPOINT [ "/entrypoint.sh" ]
