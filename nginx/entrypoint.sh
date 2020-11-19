#!/bin/sh

syslogConfig="/etc/syslog.conf"
keepalivedLog="/var/log/keepalived.log"
keepalivedConfig="/etc/keepalived/keepalived.conf"
keepalivedCmd="keepalived -f ${keepalivedConfig} --log-facility=0 --dont-fork --log-detail --dump-conf"
nginxConfig="/etc/nginx/nginx.conf"

function rebuid() {
    path=$1
    if [ -e "${path}" ]; then
        rm -rf "${path}"
    fi
    mkdir -p "${path}"
}

rebuid /run/nginx
rebuid /run/keepalived

if [ "${RUN_KEEPALIVED}" = "true" ]; then
    /docker-entrypoint.sh "nginx" "-c" "${nginxConfig}"

    echo "local0.* ${keepalivedLog}" >> "${syslogConfig}"
    syslogd -f "${syslogConfig}"

    counter="$(grep '{{ KEEPALIVED_INTERFACE }}' /etc/keepalived/keepalived.conf | wc -l)"
    if [ "${counter}" != "0" ]; then
        sed -i "s|{{ KEEPALIVED_INTERFACE }}|$KEEPALIVED_INTERFACE|g" "${keepalivedConfig}"
        sed -i "s|{{ KEEPALIVED_STATE }}|$KEEPALIVED_STATE|g" "${keepalivedConfig}"
        sed -i "s|{{ KEEPALIVED_ROUTER_ID }}|$KEEPALIVED_ROUTER_ID|g" "${keepalivedConfig}"
        sed -i "s|{{ KEEPALIVED_PRIORITY }}|$KEEPALIVED_PRIORITY|g" "${keepalivedConfig}"
        sed -i "s|{{ KEEPALIVED_PASSWORD }}|$KEEPALIVED_PASSWORD|g" "${keepalivedConfig}"
        sed -i "s|{{ KEEPALIVED_VIRTUAL_IP }}|$KEEPALIVED_VIRTUAL_IP|g" "${keepalivedConfig}"
    fi

    # keepalived -f "${keepalivedConfig}" --log-facility=0 --dont-fork --dump-conf --log-detail --log-console
    keepalivedCmd="${keepalivedCmd} --log-console"
    eval "${keepalivedCmd}"
else
    /docker-entrypoint.sh "nginx" "-g" "daemon off;"
fi
