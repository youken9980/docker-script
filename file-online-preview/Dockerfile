FROM youken9980/build-tools-openjdk8:latest as temp
LABEL maintainer="YangJian <youken9980@163.com>"

ENV GIT_URL="https://gitee.com/kekingcn/file-online-preview.git"
ENV PROJ_SRC="/proj-src"
ENV GIT_TAG="v3.5"

RUN git clone ${GIT_URL} ${PROJ_SRC} && \
    cd ${PROJ_SRC} && \
    git checkout ${GIT_TAG} && \
    mvn clean package -Dmaven.test.skip=true -U
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    mkdir -p /kkFileView/config /kkFileView/bin && \
    cp ${PROJ_SRC}/server/src/main/config/application.properties /kkFileView/config/application.properties && \
    cp ${PROJ_SRC}/server/target/kkFileView-$PROJ_VERSION.jar /kkFileView/bin/kkFileView.jar


FROM openjdk:8-jre-slim-buster
LABEL maintainer="YangJian <youken9980@163.com>"

ENV SHELL="/bin/bash"
ENV LANG="zh_CN.UTF-8"
ENV LANGUAGE="zh_CN.UTF-8"
ENV LC_ALL="zh_CN.UTF-8"
ENV TZ="Asia/Shanghai"

COPY --chown=root:root --from=temp /kkFileView /kkFileView

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    sed -i "s|# export LS_OPTIONS='--color=auto'|export LS_OPTIONS='--color=auto'|g" /root/.bashrc && \
    sed -i 's|# eval "`dircolors`"|eval "`dircolors`"|g' /root/.bashrc && \
    sed -i "s|# alias ls='ls \$LS_OPTIONS'|alias ls='ls \$LS_OPTIONS'|g" /root/.bashrc && \
    sed -i "s|# alias ll='ls \$LS_OPTIONS -l'|alias ll='ls \$LS_OPTIONS -la'|g" /root/.bashrc && \
    sed -i "s|# alias l='ls \$LS_OPTIONS -lA'|alias l='ls \$LS_OPTIONS -lA'|g" /root/.bashrc && \
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
    \
    apt-get install -y --no-install-recommends \
        procps axel aptitude locales \
        ttf-mscorefonts-installer fontconfig \
        ttf-wqy-microhei ttf-wqy-zenhei xfonts-intl-chinese xfonts-wqy \
        libxrender1 libxt6 libxext-dev libfreetype6-dev && \
    \
    echo "locales locales/default_environment_locale select zh_CN.UTF-8" | debconf-set-selections && \
    echo "locales locales/locales_to_be_generated multiselect zh_CN.UTF-8 UTF-8" | debconf-set-selections && \
    rm "/etc/locale.gen" && \
    dpkg-reconfigure --frontend noninteractive locales && \
    mkfontscale &&\
    mkfontdir &&\
    fc-cache -f && \
    \
    OPENOFFICE_VERSION="4.1.9" && \
    OPENOFFICE_DOWNLOAD_URL="https://jaist.dl.sourceforge.net/project/openofficeorg.mirror/${OPENOFFICE_VERSION}/binaries/en-US/Apache_OpenOffice_${OPENOFFICE_VERSION}_Linux_x86-64_install-deb_en-US.tar.gz" && \
    axel -n 32 -o /tmp/openoffice_install_deb.tar.gz ${OPENOFFICE_DOWNLOAD_URL} && \
    tar -zxvf /tmp/openoffice_install_deb.tar.gz -C /tmp && \
    dpkg -i /tmp/en-US/DEBS/*.deb /tmp/en-US/DEBS/desktop-integration/*.deb && \
    \
    apt-get clean && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8012

ENV KKFILEVIEW_BIN_FOLDER="/kkFileView/bin"
ENV KK_OFFICE_HOME="/opt/openoffice4"

WORKDIR ${KKFILEVIEW_BIN_FOLDER}
# java -Dfile.encoding=UTF8 -Dsun.jnu.encoding=UTF8 -Dspring.config.location=../config/application.properties -jar kkFileView.jar
CMD ["java", "-Dfile.encoding=UTF8", "-Dsun.jnu.encoding=UTF8", "-Dspring.config.location=../config/application.properties", "-jar", "kkFileView.jar"]
