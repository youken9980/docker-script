#!/bin/bash

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

result=`echo -e "\n" | telnet $HOST $PORT 2>/dev/null | grep Connected | wc -l`
if [ $result -gt 0 ]; then
      echo "Network $HOST $PORT is Open."
      exit 0
else
      echo "Network $HOST $PORT is Closed."
      exit 1
fi
