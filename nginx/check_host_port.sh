#!/bin/sh

HOST=$1
PORT=$2
if [ $# -ne 2 ]; then
    echo "Usage:"
    echo "  $0 [HOST|DOMAIN] [PORT]"
    echo ""
    echo "Examples:"
    echo "  $0 localhost 80"
    echo "  $0 192.168.1.1 80"
    exit
fi

counter=`echo -e "\n" | telnet $HOST $PORT 2>/dev/null | grep Connected | wc -l`
if [ "${counter}" = "0" ]; then
    echo "Network $HOST $PORT is Closed."
    ps -C keepalived --no-heading | head -1 | awk '{ print$1 }' | xargs kill -9
    exit 1
else
    echo "Network $HOST $PORT is Open."
    exit 0
fi
