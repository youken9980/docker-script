#!/bin/sh

cmdCheck="ps aux --no-heading | grep 'nginx' | grep 'master' | grep -v '<defunct>' | wc -l"
cmdNginx="nginx -c /etc/nginx/nginx.conf"
counter="$(eval ${cmdCheck})"
if [ "${counter}" = "0" ]; then
    echo "Starting nginx..."
    eval ${cmdNginx}
    sleep 2
    counter="$(eval ${cmdCheck})"
    if [ "${counter}" = "0" ]; then
        echo "Start nginx failed, kill keepalived."
        ps -C keepalived --no-heading | head -1 | awk '{ print$1 }' | xargs kill -9
    else
        echo "Nginx started."
    fi
fi
