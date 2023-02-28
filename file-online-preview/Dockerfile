FROM youken9980/build-tools-openjdk8:latest as temp

ENV GIT_URL="https://github.com/kekingcn/kkFileView.git"
ENV PROJ_SRC="/proj-src"

RUN git clone --depth=1 ${GIT_URL} ${PROJ_SRC}
WORKDIR ${PROJ_SRC}
RUN mvn clean package -Dmaven.test.skip=true -U
RUN PROJ_VERSION="$(xpath -q -e '//project/version/text()' ${PROJ_SRC}/pom.xml)" && \
    mkdir -p /kkFileView/config /kkFileView/bin && \
    cp ${PROJ_SRC}/server/src/main/config/application.properties /kkFileView/config/application.properties && \
    cp ${PROJ_SRC}/server/target/kkFileView-$PROJ_VERSION.jar /kkFileView/bin/kkFileView.jar


FROM youken9980/openjdk:17-jre-jammy
LABEL maintainer="YangJian <youken9980@163.com>"

ENV KKFILEVIEW_HOME="/kkFileView"
ENV KK_OFFICE_HOME="/opt/openoffice4"

RUN set -eux && \
    OPENOFFICE_VERSION="4.1.13" && \
    OPENOFFICE_DOWNLOAD_URL="https://jaist.dl.sourceforge.net/project/openofficeorg.mirror/${OPENOFFICE_VERSION}/binaries/en-US/Apache_OpenOffice_${OPENOFFICE_VERSION}_Linux_x86-64_install-deb_en-US.tar.gz" && \
    \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" && \
    apt-get install --no-install-recommends -y \
        procps aptitude \
        ttf-mscorefonts-installer ttf-wqy-microhei ttf-wqy-zenhei xfonts-intl-chinese xfonts-wqy \
        libxrender1 libxt6 libxext-dev libfreetype6-dev && \
    mkfontscale && \
    mkfontdir && \
    \
    axel -n 8 -o /tmp/openoffice.tar.gz ${OPENOFFICE_DOWNLOAD_URL} && \
    tar -zxvf /tmp/openoffice.tar.gz -C /tmp --strip-components=1 --no-same-owner && \
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
