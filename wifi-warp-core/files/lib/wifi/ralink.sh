#!/bin/sh
append DRIVERS "ralink"

devidx=0

write_ralink() {
	local dir=$1
	local devtype=$2
	local dev=$3
	local mode=$4
#	local channel=$5
	local sta=apcli0

	[ -d /sys/module/$dir ] || return
	[ -d "/sys/class/net/$dev" ] || return

	cat <<EOF
config wifi-device	radio0
	option type     ralink
	option variant	$devtype
	option country	US
	option hwmode	$mode
	option htmode	HT40
	option channel  auto
	option disabled	0
	option device_mode apsta
	option op_mode preference

config wifi-iface ap
	option device   radio0
	option mode	ap
	option network  wlan
	option ifname   $dev
	option ssid	Omega-$(cat /sys/class/net/eth0/address|awk -F ":" '{print $5""$6}'| tr a-z A-Z)
	option encryption psk2
	option key 12345678
	option disabled 0

config wifi-iface sta
	option device   radio0
	option mode	sta
	option network  wwan
	option ifname   $sta
	option ssid	YourSsidHere
	option key	YourPasswordHere
	option encryption psk2
	option disabled 1
EOF
}

detect_ralink() {
	[ -z "$(uci get wireless.@wifi-device[-1].type 2> /dev/null)" ] || return 0

	cpu=$(awk 'BEGIN{FS="[ \t]+: MediaTek[ \t]"} /system type/ {print $2}' /proc/cpuinfo | cut -d" " -f1)
	case $cpu in
	MT7688)
		write_ralink mt_wifi mt7628 ra0 11g
		;;
	esac

	return 0
}
