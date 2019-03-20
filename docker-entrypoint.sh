#!/bin/bash

echo >&2 "Shadowsocks start..."
ss-local -s $SERVER_ADDR -p $SERVER_PORT -l $LOCAL_PORT -b $LOCAL_ADDR -k ${PASSWORD:-$(hostname)} -m $METHOD -t $TIMEOUT $ARGS