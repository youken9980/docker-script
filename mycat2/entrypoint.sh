#!/bin/bash

set -eux

pidFile="/mycat/logs/mycat.pid"
if [ -e "${pidFile}" ]; then
    rm "${pidFile}"
fi

mycat start
sleep 2s
# tail -n +1 /mycat/logs/wrapper.log | sed '/mycat[[:space:]]starts[[:space:]]successful/q'
tail -n +1 -f /mycat/logs/wrapper.log
