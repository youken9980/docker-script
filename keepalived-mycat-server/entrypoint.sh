#!/bin/bash

syslogConfig="/etc/rsyslog.conf"
keepalivedLog="/var/log/keepalived.log"
keepalivedConfig="/etc/keepalived/keepalived.conf"

echo "local0.* ${keepalivedLog}" >> "${syslogConfig}"
rsyslogd -f "${syslogConfig}"

mycat start

counter="$(grep '{{ KEEPALIVED_INTERFACE }}' /etc/keepalived/keepalived.conf | wc -l)"
if [ "${counter}" != "0" ]; then
    sed -i "s|{{ KEEPALIVED_INTERFACE }}|$KEEPALIVED_INTERFACE|g" "${keepalivedConfig}"
    sed -i "s|{{ KEEPALIVED_STATE }}|$KEEPALIVED_STATE|g" "${keepalivedConfig}"
    sed -i "s|{{ KEEPALIVED_ROUTER_ID }}|$KEEPALIVED_ROUTER_ID|g" "${keepalivedConfig}"
    sed -i "s|{{ KEEPALIVED_PRIORITY }}|$KEEPALIVED_PRIORITY|g" "${keepalivedConfig}"
    sed -i "s|{{ KEEPALIVED_PASSWORD }}|$KEEPALIVED_PASSWORD|g" "${keepalivedConfig}"
    sed -i "s|{{ KEEPALIVED_VIRTUAL_IP }}|$KEEPALIVED_VIRTUAL_IP|g" "${keepalivedConfig}"
fi
# nohup keepalived -f "${keepalivedConfig}" --log-facility=0 --dont-fork --log-console --log-detail --dump-conf >> /dev/null 2>&1 &

# tail -f --pid=$(ps aux | grep "/usr/local/mycat" | grep "wrapper" | awk '{print $2}') /usr/local/mycat/logs/wrapper.log | sed '/MyCAT[[:space:]]Server[[:space:]]startup[[:space:]]successfully/q'
# tail -f /usr/local/mycat/logs/mycat.log

keepalived -f "${keepalivedConfig}" --log-facility=0 --dont-fork --log-console --log-detail --dump-conf
