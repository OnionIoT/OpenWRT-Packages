#!/bin/sh /etc/rc.common
# Copyright (C) 2019 Onion Corporation
START=90

USE_PROCD=1

BIN="lted"
APN=$(uci -q get onion.@onion[0].apn)
IFN=$(uci -q get network.lte.ifname)

start_service() {
    [ "$APN" != "" ] && [ "$IFN" != "" ] && {
        # do lted-run stuff locally
        ifconfig $IFN down
        echo "Y" > /sys/class/net/$IFN/qmi/raw_ip

        procd_open_instance
        procd_set_param command $BIN -s $APN
        procd_set_param respawn  # respawn the service if it exits
        procd_set_param stdout 1 # forward stdout of the command to logd
        procd_set_param stderr 1 # same for stderr
        procd_close_instance
    }
}
