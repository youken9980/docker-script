#!/bin/sh

sed -i "s|{{ KEEPALIVED_INTERFACE }}|$KEEPALIVED_INTERFACE|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ KEEPALIVED_STATE }}|$KEEPALIVED_STATE|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ KEEPALIVED_ROUTER_ID }}|$KEEPALIVED_ROUTER_ID|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ KEEPALIVED_PRIORITY }}|$KEEPALIVED_PRIORITY|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ KEEPALIVED_PASSWORD }}|$KEEPALIVED_PASSWORD|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ KEEPALIVED_VIRTUAL_IP }}|$KEEPALIVED_VIRTUAL_IP|g" /etc/keepalived/keepalived.conf

nginx -c /etc/nginx/nginx.conf
keepalived -f /etc/keepalived/keepalived.conf --dont-fork --log-console --log-detail --dump-conf
