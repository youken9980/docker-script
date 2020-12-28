#!/bin/sh

cmdCheck="mycat status | grep 'Mycat-server is running' | wc -l"
cmdStart="mycat start"
counter="$(eval ${cmdCheck})"
if [ "${counter}" = "0" ]; then
    echo "Starting mycat..."
    eval ${cmdStart}
    sleep 2
    counter="$(eval ${cmdCheck})"
    if [ "${counter}" = "0" ]; then
        echo "Start mycat failed, kill keepalived."
        ps -C keepalived --no-heading | head -1 | awk '{ print$1 }' | xargs kill -9
    else
        echo "Mycat started."
    fi
fi
