FROM youken9980/build-tools-temurin8:repository as temp

ENV GIT_URL="https://gitee.com/kekingcn/file-online-preview.git"
ENV PROJ_SRC="/proj-src"
ENV KKFILEVIEW_HOME="/kkFileView"

RUN git clone --depth=1 ${GIT_URL} ${PROJ_SRC}

# https://releases.aspose.com/java/repo/com/aspose/aspose-cad/23.7/aspose-cad-23.7.pom
# https://releases.aspose.com/java/repo/com/aspose/aspose-cad/23.7/aspose-cad-23.7.jar
# https://releases.aspose.com/java/repo/com/aspose/aspose-cad/23.7/aspose-cad-23.7-javadoc.jar
RUN ASPOSE_VERSION="$(xpath -q -e '//project/properties/aspose-cad.version/text()' ${PROJ_SRC}/pom.xml)" && \
    mkdir -p ${MAVEN_REPO}/com/aspose/aspose-cad/${ASPOSE_VERSION} && \
    cd ${MAVEN_REPO}/com/aspose/aspose-cad/${ASPOSE_VERSION} && \
    axel -n 8 https://releases.aspose.com/java/repo/com/aspose/aspose-cad/${ASPOSE_VERSION}/aspose-cad-${ASPOSE_VERSION}.pom && \
    axel -n 8 https://releases.aspose.com/java/repo/com/aspose/aspose-cad/${ASPOSE_VERSION}/aspose-cad-${ASPOSE_VERSION}.jar

WORKDIR ${PROJ_SRC}
RUN mvn clean package -Dmaven.test.skip=true -U
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    cp ${PROJ_SRC}/server/target/kkFileView-${PROJ_VERSION}.tar.gz /kkFileView.tar.gz && \
    mkdir -p ${KKFILEVIEW_HOME} && \
    tar -zxvf /kkFileView.tar.gz -C ${KKFILEVIEW_HOME} --strip-components=1 --no-same-owner && \
    mv ${KKFILEVIEW_HOME}/bin/kkFileView-${PROJ_VERSION}.jar ${KKFILEVIEW_HOME}/bin/kkFileView.jar


FROM youken9980/temurin:8-jre-jammy
LABEL maintainer="YangJian <youken9980@163.com>"

ENV LIBREOFFICE_VERSION="7.6.6"
ENV KK_OFFICE_HOME="/opt/libreoffice7.6"
ENV KKFILEVIEW_HOME="/kkFileView"

RUN set -eux && \
    apt-get update && \
    apt-get install -y --reinstall ca-certificates && \
    apt-get clean && apt-get update && \
    export DEBIAN_FRONTEND="noninteractive" && \
    apt-get install -y tzdata locales language-pack-zh-hans \
                       fontconfig ttf-mscorefonts-installer ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy \
                       libxrender1 libxinerama1 libxt6 libxext-dev libfreetype6-dev libcairo2 libcups2 libx11-xcb1 libnss3 \
                       procps aptitude axel && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 && \
    locale-gen zh_CN.UTF-8 && \
    mkfontscale && \
    mkfontdir && \
    fc-cache -fv && \
    \
    axel -n 8 -o /tmp/libreoffice_deb.tar.gz https://www.mirrorservice.org/sites/download.documentfoundation.org/tdf/libreoffice/stable/${LIBREOFFICE_VERSION}/deb/x86_64/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz && \
    mkdir -p /tmp/libreoffice && \
    tar -zxvf /tmp/libreoffice_deb.tar.gz -C /tmp/libreoffice --strip-components=1 --no-same-owner && \
    cd /tmp/libreoffice/DEBS && \
    dpkg -i *.deb && \
    \
    rm -rf /var/lib/apt/lists/* \
           /var/cache/* \
           /tmp/*

COPY --chown=root:root --from=temp ${KKFILEVIEW_HOME} ${KKFILEVIEW_HOME}

EXPOSE 8012

WORKDIR ${KKFILEVIEW_HOME}/bin

# nohup java -Duser.timezone=GMT+8 -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -Dspring.config.location=../config/application.properties -jar kkFileView-4.3.0.jar > ../log/kkFileView.log 2>&1 &
CMD ["java", "-Duser.timezone=GMT+8", "-Dfile.encoding=UTF-8", "-Dsun.jnu.encoding=UTF-8", "-Dspring.config.location=../config/application.properties", "-jar", "kkFileView.jar"]


# ENV KK_OFFICE_HOME="/opt/openoffice4"

# RUN set -eux && \
#     OPENOFFICE_VERSION="4.1.14" && \
#     OPENOFFICE_DOWNLOAD_URL="https://jaist.dl.sourceforge.net/project/openofficeorg.mirror/${OPENOFFICE_VERSION}/binaries/en-US/Apache_OpenOffice_${OPENOFFICE_VERSION}_Linux_x86-64_install-deb_en-US.tar.gz" && \
#     \
#     apt-get update && \
#     DEBIAN_FRONTEND="noninteractive" && \
#     apt-get install --no-install-recommends -y \
#         procps aptitude \
#         ttf-mscorefonts-installer ttf-wqy-microhei ttf-wqy-zenhei xfonts-intl-chinese xfonts-wqy \
#         libxrender1 libxt6 libxext-dev libfreetype6-dev && \
#     mkfontscale && \
#     mkfontdir && \
#     \
#     wget -O /tmp/openoffice.tar.gz ${OPENOFFICE_DOWNLOAD_URL} && \
#     tar -zxvf /tmp/openoffice.tar.gz -C /tmp --strip-components=1 --no-same-owner && \
#     dpkg -i /tmp/DEBS/*.deb /tmp/DEBS/desktop-integration/*.deb && \
#     \
#     rm -rf /var/lib/apt/lists/* \
#            /var/cache/* \
#            /tmp/* \
#            /opt/openoffice4/help

# COPY --chown=root:root --from=temp ${KKFILEVIEW_HOME} ${KKFILEVIEW_HOME}

# EXPOSE 8012

# WORKDIR ${KKFILEVIEW_HOME}/bin

# # java -Duser.timezone=GMT+8 -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -Dspring.config.location=../config/application.properties -jar kkFileView-4.3.0.jar
# CMD ["java", "-Duser.timezone=GMT+8", "-Dfile.encoding=UTF-8", "-Dsun.jnu.encoding=UTF-8", "-Dspring.config.location=../config/application.properties", "-jar", "kkFileView.jar"]
