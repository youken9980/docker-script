FROM youken9980/build-tools-openjdk8:latest as temp

ENV GITHUB_MIRROR="https://github.com"
ENV GIT_URL="${GITHUB_MIRROR}/kekingcn/kkFileView.git"
ENV PROJ_SRC="/proj-src"

RUN git clone --depth=1 ${GIT_URL} ${PROJ_SRC}
WORKDIR ${PROJ_SRC}
RUN mvn clean package -Dmaven.test.skip=true -U
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    mkdir -p /kkFileView/config /kkFileView/bin && \
    cp ${PROJ_SRC}/server/src/main/config/application.properties /kkFileView/config/application.properties && \
    cp ${PROJ_SRC}/server/target/kkFileView-$PROJ_VERSION.jar /kkFileView/bin/kkFileView.jar


FROM openjdk:8-jre-slim-bullseye
LABEL maintainer="YangJian <youken9980@163.com>"

ENV SHELL="/bin/bash"
ENV TZ="Asia/Shanghai"
ENV LANG="zh_CN.UTF-8"
ENV LANGUAGE="zh_CN.UTF-8"
ENV LC_ALL="zh_CN.UTF-8"
ENV KKFILEVIEW_HOME="/kkFileView"
ENV KK_OFFICE_HOME="/opt/openoffice4"

RUN set -eux && \
    \
    mv /usr/share/zoneinfo/PRC /PRC && \
    rm -rf /usr/share/zoneinfo && \
    mkdir -p /usr/share/zoneinfo/Asia && \
    mv /PRC /usr/share/zoneinfo/PRC && \
    ln -sTf /usr/share/zoneinfo/PRC /usr/share/zoneinfo/Asia/Shanghai && \
    ln -sTf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    \
    sed -i "s|# export LS_OPTIONS='--color=auto'|export LS_OPTIONS='--color=auto'|g" /root/.bashrc && \
    sed -i 's|# eval "`dircolors`"|eval "`dircolors`"|g' /root/.bashrc && \
    sed -i "s|# alias ls='ls \$LS_OPTIONS'|alias ls='ls \$LS_OPTIONS'|g" /root/.bashrc && \
    sed -i "s|# alias ll='ls \$LS_OPTIONS -l'|alias ll='ls \$LS_OPTIONS -la'|g" /root/.bashrc && \
    sed -i "s|# alias l='ls \$LS_OPTIONS -lA'|alias l='ls \$LS_OPTIONS -lA'|g" /root/.bashrc && \
    \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    DEBIAN_MIRROR="http://mirrors.tuna.tsinghua.edu.cn" && \
    echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释" >> /etc/apt/sources.list && \
    echo "deb ${DEBIAN_MIRROR}/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list && \
    echo "# deb-src ${DEBIAN_MIRROR}/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb ${DEBIAN_MIRROR}/debian/ bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "# deb-src ${DEBIAN_MIRROR}/debian/ bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb ${DEBIAN_MIRROR}/debian/ bullseye-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "# deb-src ${DEBIAN_MIRROR}/debian/ bullseye-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb ${DEBIAN_MIRROR}/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
    echo "# deb-src ${DEBIAN_MIRROR}/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
    \
    apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https ca-certificates && \
    sed -i "s|http://|https://|g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        axel procps aptitude locales \
        ttf-mscorefonts-installer fontconfig \
        ttf-wqy-microhei ttf-wqy-zenhei xfonts-intl-chinese xfonts-wqy \
        libxrender1 libxt6 libxext-dev libfreetype6-dev && \
    \
    echo "locales locales/default_environment_locale select zh_CN.UTF-8" | debconf-set-selections && \
    echo "locales locales/locales_to_be_generated multiselect zh_CN.UTF-8 UTF-8" | debconf-set-selections && \
    rm "/etc/locale.gen" && \
    dpkg-reconfigure --frontend noninteractive locales && \
    mkfontscale && \
    mkfontdir && \
    fc-cache -f && \
    \
    FILE_NAME="openoffice_install_deb" && \
    OPENOFFICE_VERSION="4.1.12" && \
    OPENOFFICE_DOWNLOAD_URL="https://udomain.dl.sourceforge.net/project/openofficeorg.mirror/${OPENOFFICE_VERSION}/binaries/en-US/Apache_OpenOffice_${OPENOFFICE_VERSION}_Linux_x86-64_install-deb_en-US.tar.gz" && \
    axel -n 32 -o /tmp/${FILE_NAME}.tgz ${OPENOFFICE_DOWNLOAD_URL} && \
    tar --strip 1 -zxvf /tmp/${FILE_NAME}.tgz -C /tmp && \
    dpkg -i /tmp/DEBS/*.deb /tmp/DEBS/desktop-integration/*.deb && \
    \
    rm -rf /var/lib/apt/lists/* \
           /var/cache/* \
           /tmp/* \
           /opt/openoffice4/help

COPY --chown=root:root --from=temp ${KKFILEVIEW_HOME} ${KKFILEVIEW_HOME}

EXPOSE 8012

WORKDIR ${KKFILEVIEW_HOME}/bin

# java -Duser.timezone=GMT+8 -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -Dspring.config.location=../config/application.properties -jar kkFileView.jar
CMD ["java", "-Duser.timezone=GMT+8", "-Dfile.encoding=UTF-8", "-Dsun.jnu.encoding=UTF-8", "-Dspring.config.location=../config/application.properties", "-jar", "kkFileView.jar"]
