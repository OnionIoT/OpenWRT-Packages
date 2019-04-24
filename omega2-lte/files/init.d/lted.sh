#!/bin/sh /etc/rc.common
# Copyright (C) 2019 Onion Corporation
START=90

USE_PROCD=1

BIN="lted-run"
APN=$(uci -q get onion.@onion[0].apn)

start_service() {
    [ "$APN" != "" ] && {
        procd_open_instance
        procd_set_param command $BIN $APN
        procd_set_param respawn  # respawn the service if it exits
        procd_set_param stdout 1 # forward stdout of the command to logd
        procd_set_param stderr 1 # same for stderr
        procd_close_instance
    }
}