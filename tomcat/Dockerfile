FROM youken9980/openjdk:8-jdk-alpine
LABEL maintainer="YangJian <youken9980@163.com>"

ENV TOMCAT_MAJOR="9"
ENV TOMCAT_VERSION="9.0.52"
ENV CATALINA_HOME="/usr/local/tomcat"
ENV PATH="$CATALINA_HOME/bin:$PATH"

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR="$CATALINA_HOME/native-jni-lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR"

RUN set -eux && \
    mkdir -p "$CATALINA_HOME" && \
    cd "$CATALINA_HOME" && \
    axel -n 32 -o tomcat.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar -zxvf tomcat.tar.gz --strip-components=1 && \
    rm tomcat.tar.gz \
       bin/*.bat && \
    \
    nativeBuildDir="$(mktemp -d)" && \
    tar -zxvf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1 && \
    cd "$nativeBuildDir/native" && \
    apk add --no-cache --virtual .fetch-deps \
            ca-certificates \
            tar \
            openssl && \
    apk add --no-cache --virtual .native-build-deps \
            apr-dev \
            dpkg-dev dpkg \
            gcc \
            libc-dev \
            make \
            openssl-dev && \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    ./configure \
            --build="$gnuArch" \
            --libdir="$TOMCAT_NATIVE_LIBDIR" \
            --prefix="$CATALINA_HOME" \
            --with-apr="$(which apr-1-config)" \
            --with-java-home="$JAVA_HOME" \
            --with-ssl=yes && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    runDeps="$( \
            scanelf --needed --nobanner --recursive "$TOMCAT_NATIVE_LIBDIR" \
                    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                    | sort -u \
                    | xargs -r apk info --installed \
                    | sort -u \
    )" && \
    apk add --no-cache --virtual .tomcat-native-rundeps $runDeps && \
    apk del .fetch-deps .native-build-deps && \
    \
    cd "$CATALINA_HOME" && \
    rm -rf "$nativeBuildDir" \
           bin/tomcat-native.tar.gz \
           webapps/*

# verify Tomcat Native is working properly
RUN set -eux && \
    nativeLines="$(catalina.sh configtest 2>&1)" && \
    nativeLines="$(echo "$nativeLines" | grep 'Apache Tomcat Native')" && \
    nativeLines="$(echo "$nativeLines" | sort -u)" && \
    if ! echo "$nativeLines" | grep 'INFO: Loaded Apache Tomcat Native library' >&2; then \
        echo >&2 "$nativeLines"; \
        exit 1; \
    fi

WORKDIR $CATALINA_HOME

EXPOSE 8080

STOPSIGNAL SIGTERM

CMD ["catalina.sh", "run"]
