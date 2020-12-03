#!/bin/sh

cmdCheck="ps aux --no-heading | grep 'nginx' | grep 'master' | grep -v '<defunct>' | wc -l"
cmdStartNginx="nginx -c /etc/nginx/nginx.conf"
cmdStopKeepalived="ps -C keepalived --no-heading | head -1 | awk '{ print$1 }' | xargs kill -9"
counter="$(eval ${cmdCheck})"
if [ "${counter}" = "0" ]; then
    echo "Starting nginx..."
    eval "${cmdStartNginx}"
    sleep 2
    counter="$(eval ${cmdCheck})"
    if [ "${counter}" = "0" ]; then
        echo "Start nginx failed, kill keepalived."
        eval "${cmdStopKeepalived}"
    else
        echo "Nginx started."
    fi
fi
