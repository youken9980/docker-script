#!/bin/bash

/usr/local/bin/realServerVip.sh start
mycat start
sleep 1s
tail -f --pid=$(ps aux | grep /usr/local/mycat | grep wrapper | awk '{print $2}') /usr/local/mycat/logs/wrapper.log | sed '/MyCAT[[:space:]]Server[[:space:]]startup[[:space:]]successfully/q'
tail -f /usr/local/mycat/logs/mycat.log
