FROM youken9980/build-tools-openjdk8:latest as temp

ENV GIT_URL="https://gitee.com/kekingcn/file-online-preview.git"
ENV PROJ_SRC="/proj-src"
# ENV GIT_TAG="v3.5"
ENV GIT_TAG="master"

RUN git clone ${GIT_URL} ${PROJ_SRC} && \
    cd ${PROJ_SRC} && \
    git checkout ${GIT_TAG} && \
    mvn clean package -Dmaven.test.skip=true -U
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    mkdir -p /kkFileView/config /kkFileView/bin && \
    cp ${PROJ_SRC}/server/src/main/config/application.properties /kkFileView/config/application.properties && \
    cp ${PROJ_SRC}/server/target/kkFileView-$PROJ_VERSION.jar /kkFileView/bin/kkFileView.jar


FROM youken9980/openjdk:8-jre-slim-buster
LABEL maintainer="YangJian <youken9980@163.com>"

ENV LANG="zh_CN.UTF-8"
ENV LANGUAGE="zh_CN.UTF-8"
ENV LC_ALL="zh_CN.UTF-8"
ENV KKFILEVIEW_HOME="/kkFileView"
ENV KK_OFFICE_HOME="/opt/openoffice4"

COPY --chown=root:root --from=temp ${KKFILEVIEW_HOME} ${KKFILEVIEW_HOME}

RUN set -eux && \
    \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        procps aptitude locales \
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
    FILE_NAME="openoffice_install_deb" && \
    OPENOFFICE_VERSION="4.1.9" && \
    OPENOFFICE_DOWNLOAD_URL="https://jaist.dl.sourceforge.net/project/openofficeorg.mirror/${OPENOFFICE_VERSION}/binaries/en-US/Apache_OpenOffice_${OPENOFFICE_VERSION}_Linux_x86-64_install-deb_en-US.tar.gz" && \
    axel -n 32 -o /tmp/${FILE_NAME}.tgz ${OPENOFFICE_DOWNLOAD_URL} && \
    tar --strip 1 -zxvf /tmp/${FILE_NAME}.tgz -C /tmp && \
    dpkg -i /tmp/DEBS/*.deb /tmp/DEBS/desktop-integration/*.deb && \
    \
    rm -rf /var/lib/apt/lists/* \
           /var/cache/* \
           /tmp/* \
           /opt/openoffice4/help

EXPOSE 8012

WORKDIR ${KKFILEVIEW_HOME}/bin
# java -Dfile.encoding=UTF8 -Dsun.jnu.encoding=UTF8 -Dspring.config.location=../config/application.properties -jar kkFileView.jar
CMD ["java", "-Dfile.encoding=UTF8", "-Dsun.jnu.encoding=UTF8", "-Dspring.config.location=../config/application.properties", "-jar", "kkFileView.jar"]
