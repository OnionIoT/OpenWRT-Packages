#!/bin/sh /etc/rc.common
# (C) 2018 Onion Corporation

START=88
SCRIPT="/usr/bin/o2-pro-init"

boot() {
	/bin/sh $SCRIPT
}
