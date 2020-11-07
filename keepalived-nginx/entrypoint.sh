#!/bin/sh

syslogConfig="/etc/syslog.conf"
keepalivedLog="/var/log/keepalived.log"
keepalivedConfig="/etc/keepalived/keepalived.conf"
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

echo "local0.* ${keepalivedLog}" >> "${syslogConfig}"
syslogd -f "${syslogConfig}"

nginx -c "${nginxConfig}"

sed -i "s|{{ KEEPALIVED_INTERFACE }}|$KEEPALIVED_INTERFACE|g" "${keepalivedConfig}"
sed -i "s|{{ KEEPALIVED_STATE }}|$KEEPALIVED_STATE|g" "${keepalivedConfig}"
sed -i "s|{{ KEEPALIVED_ROUTER_ID }}|$KEEPALIVED_ROUTER_ID|g" "${keepalivedConfig}"
sed -i "s|{{ KEEPALIVED_PRIORITY }}|$KEEPALIVED_PRIORITY|g" "${keepalivedConfig}"
sed -i "s|{{ KEEPALIVED_PASSWORD }}|$KEEPALIVED_PASSWORD|g" "${keepalivedConfig}"
sed -i "s|{{ KEEPALIVED_VIRTUAL_IP }}|$KEEPALIVED_VIRTUAL_IP|g" "${keepalivedConfig}"
keepalived -f "${keepalivedConfig}" --log-facility=0 --dont-fork --log-console --log-detail --dump-conf