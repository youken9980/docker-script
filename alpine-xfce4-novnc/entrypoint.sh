#!/bin/bash

set -eux

# source /etc/profile

mkdir -p "$HOME/.x11vnc"
PASSWD_PATH="$HOME/.x11vnc/passwd"

x11vnc -storepasswd $VNC_PASSWD $PASSWD_PATH
chmod 600 $PASSWD_PATH

$NOVNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NOVNC_PORT &
Xvfb $DISPLAY -screen 0 "$VNC_RESOLUTION"x"$VNC_COL_DEPTH" &
startxfce4 --replace > $HOME/wm.log 2>&1 &
sleep 1
x11vnc -noncache -xkb -noxrecord -noxfixes -noxdamage -permitfiletransfer -tightfilexfer -rfbauth $PASSWD_PATH -display $DISPLAY -forever -o $HOME/.x11vnc/x11vnc.log -bg
tail -f $HOME/.x11vnc/x11vnc.log
