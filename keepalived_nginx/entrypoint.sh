#!/bin/sh

configFilePath="/etc/keepalived/keepalived.conf"

sed -i "s|{{ KEEPALIVED_INTERFACE }}|$KEEPALIVED_INTERFACE|g" "${configFilePath}"
sed -i "s|{{ KEEPALIVED_STATE }}|$KEEPALIVED_STATE|g" "${configFilePath}"
sed -i "s|{{ KEEPALIVED_ROUTER_ID }}|$KEEPALIVED_ROUTER_ID|g" "${configFilePath}"
sed -i "s|{{ KEEPALIVED_PRIORITY }}|$KEEPALIVED_PRIORITY|g" "${configFilePath}"
sed -i "s|{{ KEEPALIVED_PASSWORD }}|$KEEPALIVED_PASSWORD|g" "${configFilePath}"
sed -i "s|{{ KEEPALIVED_VIRTUAL_IP }}|$KEEPALIVED_VIRTUAL_IP|g" "${configFilePath}"

rm /run/nginx/nginx.pid
rm /run/keepalived/*.pid

nginx -c /etc/nginx/nginx.conf
keepalived -f "${configFilePath}" --dont-fork --log-console --log-detail --dump-conf
