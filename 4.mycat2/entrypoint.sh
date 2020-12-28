#!/bin/sh

mycat start
sleep 1s
tail -n +1 -f /usr/local/mycat/logs/mycat.log
