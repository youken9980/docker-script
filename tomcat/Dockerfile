FROM youken9980/openjdk:8-jdk-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

ENV CATALINA_HOME="/usr/local/tomcat"
ENV PATH="$CATALINA_HOME/bin:$PATH"

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR="$CATALINA_HOME/native-jni-lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR:/usr/local/apr/lib"
ENV LD_RUN_PATH="${LD_RUN_PATH:+$LD_RUN_PATH:}$TOMCAT_NATIVE_LIBDIR:/usr/local/apr/lib"

RUN set -eux && \
    aprVersion="1.7.0" && \
    aprUtilVersion="1.6.1" && \
    aprIconvVersion="1.2.2" && \
    tomcatMajor="9" && \
    tomcatVersion="9.0.56" && \
    tempDir="$(mktemp -d)" && \
    npPocessors="$(getconf _NPROCESSORS_ONLN)" && \
    \
    apk add --update --no-cache --virtual .local-build-deps \
            dpkg-dev dpkg \
            expat-dev \
            gcc \
            libc-dev \
            make \
            openssl \
            openssl-dev && \
    \
    cd ${tempDir} && \
    axel -n 32 -o apr.tar.gz https://mirrors.bfsu.edu.cn/apache/apr/apr-${aprVersion}.tar.gz && \
    axel -n 32 -o apr-util.tar.gz https://mirrors.bfsu.edu.cn/apache/apr/apr-util-${aprUtilVersion}.tar.gz && \
    axel -n 32 -o apr-iconv.tar.gz https://mirrors.bfsu.edu.cn/apache/apr/apr-iconv-${aprIconvVersion}.tar.gz && \
    mkdir apr \
          apr-iconv \
          apr-util && \
    tar -zxvf apr.tar.gz -C apr --strip-components=1 && \
    tar -zxvf apr-util.tar.gz -C apr-util --strip-components=1 && \
    tar -zxvf apr-iconv.tar.gz -C apr-iconv --strip-components=1 && \
    cd ${tempDir}/apr && \
    ./configure --prefix=/usr/local/apr && \
    make -j${npPocessors} && \
    make install && \
    cd ${tempDir}/apr-util && \
    ./configure --prefix=/usr/local/apr-util \
                --with-apr=/usr/local/apr \
                --with-apr-iconv=/usr/local/apr-iconv/bin/apriconv && \
    make -j${npPocessors} && \
    make install && \
    cd ${tempDir}/apr-iconv && \
    ./configure --prefix=/usr/local/apr-iconv \
                --with-apr=/usr/local/apr && \
    make -j${npPocessors} && \
    make install && \
    \
    cd ${tempDir} && \
    axel -n 32 -o tomcat.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-${tomcatMajor}/v${tomcatVersion}/bin/apache-tomcat-${tomcatVersion}.tar.gz && \
    mkdir tomcat && \
    tar -zxvf tomcat.tar.gz -C tomcat --strip-components=1 && \
    mv tomcat ${CATALINA_HOME} && \
    mv ${CATALINA_HOME}/bin/tomcat-native.tar.gz . && \
    mkdir tomcat-native && \
    tar -zxvf tomcat-native.tar.gz -C tomcat-native --strip-components=1 && \
    cd ${tempDir}/tomcat-native/native && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
                --libdir="${TOMCAT_NATIVE_LIBDIR}" \
                --prefix="${CATALINA_HOME}" \
                --with-apr=/usr/local/apr \
                --with-java-home="${JAVA_HOME}" && \
    make -j${npPocessors} && \
    make install && \
    \
    tomcatNativeRunDeps="$( \
        scanelf --needed --nobanner --recursive "${TOMCAT_NATIVE_LIBDIR}" \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --update --no-cache ${tomcatNativeRunDeps} && \
    \
    cd / && \
    catalina.sh version && \
    \
    apk del .local-build-deps && \
    rm -rf /var/cache/apk/*.* \
           ${tempDir} \
           ${CATALINA_HOME}/bin/*.bat \
           ${CATALINA_HOME}/webapps/*

# verify Tomcat Native is working properly
RUN set -eux && \
    nativeLines="$(catalina.sh configtest 2>&1)" && \
    nativeLines="$(echo "$nativeLines" | grep 'Apache Tomcat Native')" && \
    nativeLines="$(echo "$nativeLines" | sort -u)" && \
    if ! echo "$nativeLines" | grep 'INFO: Loaded Apache Tomcat Native library' >&2; then \
        echo >&2 "$nativeLines"; \
        exit 1; \
    fi

WORKDIR $CATALINA_HOME/bin

EXPOSE 8080

STOPSIGNAL SIGTERM

CMD ["catalina.sh", "run"]
