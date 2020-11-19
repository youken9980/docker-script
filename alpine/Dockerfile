FROM alpine:latest
LABEL maintainer="YangJian <youken9980@163.com>"

ENV TZ="Asia/Shanghai"

RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories && \
    apk update && \
    apk add tzdata && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    \
    apk add which procps busybox-extras wget openssh-server && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key && \
    sed -i 's|#Port 22|Port 22|g' /etc/ssh/sshd_config && \
    sed -i 's|#ListenAddress 0.0.0.0|ListenAddress 0.0.0.0|g' /etc/ssh/sshd_config && \
    sed -i 's|#ListenAddress ::|ListenAddress ::|g' /etc/ssh/sshd_config && \
    sed -i 's|#PermitRootLogin yes|PermitRootLogin no|g' /etc/ssh/sshd_config && \
    sed -i 's|#PermitEmptyPasswords no|PermitEmptyPasswords no|g' /etc/ssh/sshd_config && \
    \
    echo "root:admin" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
