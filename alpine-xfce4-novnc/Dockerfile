FROM youken9980/alpine:3 as source-han-serif
RUN axel -n 8 -o /SourceHanSerif.ttc https://ghps.cc/https://github.com/adobe-fonts/source-han-serif/releases/download/1.001R/SourceHanSerif.ttc

# FROM youken9980/alpine:3 as source-han-sans
# RUN axel -n 8 -o /SourceHanSans.ttc https://ghps.cc/https://github.com/adobe-fonts/source-han-sans/releases/download/2.002R/SourceHanSans.ttc

# FROM youken9980/alpine:3 as source-han-mono
# RUN axel -n 8 -o /SourceHanMono.ttc https://ghps.cc/https://github.com/adobe-fonts/source-han-mono/releases/download/1.002/SourceHanMono.ttc

FROM youken9980/alpine:3 as novnc
RUN NOVNC_HOME="/noVNC" && \
    axel -n 8 -o novnc.tar.gz https://ghps.cc/https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz && \
    axel -n 8 -o websockify.tar.gz https://ghps.cc/https://github.com/novnc/websockify/archive/v0.11.0.tar.gz && \
    mkdir -p ${NOVNC_HOME}/utils/websockify && \
    tar -zxvf novnc.tar.gz -C ${NOVNC_HOME} --strip-components=1 --no-same-owner && \
    tar -zxvf websockify.tar.gz -C ${NOVNC_HOME}/utils/websockify --strip-components=1 --no-same-owner && \
    cd ${NOVNC_HOME} && \
    ln -snf vnc.html index.html


FROM youken9980/alpine:3
LABEL maintainer="YangJian <youken9980@163.com>"

ENV USER=root
ENV DISPLAY=:1
ENV HOME=/home/${USER}
ENV TERM=xterm
ENV VNC_PASSWD=alpinelinux
ENV VNC_PORT=5900
ENV VNC_RESOLUTION=1280x800
ENV VNC_COL_DEPTH=24
ENV NOVNC_PORT=6080
ENV NOVNC_HOME=${HOME}/noVNC

RUN set -eux && \
    \
    apk --update --no-cache add \
        xfce4 xfce4-terminal x11vnc xvfb \
        bash procps python3 font-adobe-100dpi \
        firefox && \
    fc-cache -f && \
    \
    rm -rf /var/cache/apk/*.*

EXPOSE $VNC_PORT $NOVNC_PORT

COPY --chown=root:root --from=source-han-serif /SourceHanSerif.ttc /usr/share/fonts/SourceHanSerif.ttc
COPY --chown=root:root --from=novnc /noVNC ${NOVNC_HOME}

COPY config /etc/skel/.config
COPY entrypoint.sh /entrypoint.sh

# RUN apk --update --no-cache add chromium && \
#     mv /usr/lib/chromium/locales/en-US*.* /. && \
#     rm -rf /usr/lib/chromium/locales && \
#     mkdir -p /usr/lib/chromium/locales && \
#     mv /en-US*.* /usr/lib/chromium/locales/. && \
#     echo "CHROMIUM_FLAGS=\"--no-sandbox --no-first-run --disable-gpu\"" >> /etc/chromium/chromium.conf

CMD ["/entrypoint.sh"]
