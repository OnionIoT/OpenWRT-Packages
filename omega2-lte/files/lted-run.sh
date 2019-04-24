#!/bin/sh
# Copyright (C) 2019 Onion Corporation

if [ "$1" == "" ]; then
    echo "ERROR: expecting APN as argument"
    exit 1
fi

BIN="lted"
APN="$1"
INTF="wwan0"

ifconfig $INTF down
echo "Y" > /sys/class/net/wwan0/qmi/raw_ip

$BIN -s $APN
