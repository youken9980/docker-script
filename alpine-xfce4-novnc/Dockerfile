FROM youken9980/alpine:latest

ENV USER=root
ENV DISPLAY=:1
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV HOME=/home/${USER}
ENV TERM=xterm
ENV VNC_PASSWD=alpinelinux
ENV VNC_PORT=5900
ENV VNC_RESOLUTION=1280x800
ENV VNC_COL_DEPTH=24 
ENV NOVNC_PORT=6080
ENV NOVNC_HOME=/home/${USER}/noVNC

RUN set -xe && \
    apk --update --no-cache add \
        ca-certificates \
        xfce4 xfce4-terminal x11vnc xvfb \
        bash procps python2 font-adobe-100dpi \
        chromium && \
    update-ca-certificates && \
    echo "CHROMIUM_FLAGS=\"--no-sandbox --no-first-run --disable-gpu\"" >> /etc/chromium/chromium.conf && \
    \
    wget -c -O /usr/share/fonts/SourceHanSerif.ttc https://hub.fastgit.org/adobe-fonts/source-han-serif/releases/download/1.001R/SourceHanSerif.ttc && \
    fc-cache -f && \
    \
    mkdir -p $NOVNC_HOME/utils/websockify && \
    wget -qO- https://hub.fastgit.org/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz --strip 1 -C $NOVNC_HOME && \
    wget -qO- https://hub.fastgit.org/novnc/websockify/archive/v0.9.0.tar.gz | tar xzf - --strip 1 -C $NOVNC_HOME/utils/websockify && \
    chmod +x -v $NOVNC_HOME/utils/*.sh && \
    cd $NOVNC_HOME && ln -snf vnc.html index.html

EXPOSE $VNC_PORT $NOVNC_PORT

COPY config /etc/skel/.config
COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
