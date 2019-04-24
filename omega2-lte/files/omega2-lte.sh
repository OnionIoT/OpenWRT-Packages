#!/bin/sh
# Copyright (C) 2019 Onion Corporation

## Omega2 LTE configuration and control script


### global variables
# options
bVerbose=0
bJson=0
bTest=0
bError=0

#commands
bCmd=0
bSetApn=0
bData=0
bGnss=0
bEnable=0
bDisable=0
bConfig=0
scriptCommand=""
scriptOption0=""

PROG_NAME="o2lte"
GNSS_AT_CMD_DEV="/dev/ttyUSB2"
GNSS_DATA_TTY="ttyUSB1"
DATA_INTF="wwan0"

usage () {
	_Print "Functionality:"
	_Print "	Configure the Omega2 LTE device for cellular connectivity"
	_Print ""
	
	_Print "Usage:"
# 	_Print "	$PROG_NAME config"
# 	_Print "		Configure the Omega2 LTE for 4G and GNSS"
# 	_Print ""
	_Print "	$PROG_NAME apn <CELLULAR NETWORK APN>"
	_Print "		Configure the Omega2 LTE to connect to your cellular provider's network" 
	_Print ""
	_Print ""
	_Print "	$PROG_NAME data enable"
	_Print "		ENABLE the cellular data connection"
	_Print ""
	_Print "	$PROG_NAME data disable"
	_Print "		DISABLE the cellular data connection"
	_Print ""
	_Print ""
	_Print "	$PROG_NAME gnss enable"
	_Print "		ENABLE collection of GNSS data"
	_Print ""
	_Print "	$PROG_NAME gnss disable"
	_Print "		DISABLE collection of GNSS data"
	_Print ""
}

#############################
##### General Functions #####
# initialize the json
_Init () {
	if [ $bJson == 1 ]; then
		# json setup
		json_init
	fi
}

# prints a message, taking json output into account
#	$1	- the message to print
#	$2	- the json index string
_Print () {
	if [ $bJson == 0 ]; then
		echo "$1"
	else
		json_add_string "$2" "$1"
	fi
}

# set an error flag
_SetError () {
	bError=1
}

# close and print the json
_Close () {
	if [ $bJson == 1 ]; then
		# print the error status
		local output=$((!$bError))
		json_add_boolean "success" $output

		# print the json
		json_dump
	fi
}

########################################
###     Omega2 LTE Functions
########################################

setNetworkConfig () {
    # configure network settings
    local ifname=$(uci -q get network.lte.ifname)
    if [ "$ifname" != "$DATA_INTF" ]; then
        _Print "> Configuring network settings"
        uci -q set network.lte=interface
        uci -q set network.lte.ifname="$DATA_INTF"
        uci -q set network.lte.proto="dhcp"
        uci commit network
        
        # restart network for changes to take effect
        /etc/init.d/network restart
    fi
}

setGpsConfig () {
    # configure network settings
    local tty=$(uci -q get gps.@gps[0].tty)
    if [ "$tty" != "$GNSS_DATA_TTY" ]; then
        _Print "> Configuring GPS settings"
        uci set gps.@gps[0].tty="$GNSS_DATA_TTY"
        uci commit gps
        
        # restart gps daemon for changes to take effect
        /etc/init.d/ugps restart
    fi
}

setupConfig () {
    setNetworkConfig
    setGpsConfig
}

setApn () {
    local apn="$1"
    if [ "$apn" != "" ]; then
        _Print "> Setting APN to $apn"
        uci set onion.@onion[0].apn="$apn"
        uci commit onion
        
        setupConfig
    else 
        _Print "ERROR: missing APN name, see script usage"
        _Print ""
        bError=1
    fi
}

lteEnable () {
    local apn=$(uci -q get onion.@onion[0].apn)
    if [ "$apn" != "" ]; then
        _Print "> Enabling LTE data connection"
        /etc/init.d/lted enable
        /etc/init.d/lted start
    else
        _Print "ERROR: need to set cellular network APN first!"
        _Print ""
        _Print "Run the following command and then retry:"
        _Print "	$PROG_NAME apn <CELLULAR NETWORK APN>"
        _Print ""
        bError=1
    fi
}

lteDisable () {
    _Print "> Disabling LTE data connection"
    /etc/init.d/lted disable
    /etc/init.d/lted stop
}

sendAtCmd () {
    local cmd="$1"
    local dev="$2" 
    echo "$cmd" > "$dev"
}

gnssEnable () {
    _Print "> Enabling GNSS data collection"
    setGpsConfig
    sendAtCmd "AT+QGPS=1" "$GNSS_AT_CMD_DEV"
}

gnssDisable () {
    _Print "> Disabling GNSS data collection"
    sendAtCmd "AT+QGPS=0" "$GNSS_AT_CMD_DEV"
}

########################################
###     Parse Arguments
########################################


# parse arguments
while [ "$1" != "" ]
do
	case "$1" in
		# options
		-v|--v|-verbose|verbose)
			bVerbose=1
			shift
		;;
		-j|--j|-json|--json|json)
			bJson=1
			shift
		;;
		-t|--t|-test|--test|test|-testing|--testing|testing)
			bTest=1
			shift
		;;
		# commands
		apn)
			bCmd=1
			bSetApn=1
			shift
			scriptOption0="$1"
			shift
		;;
		config)
			bCmd=1
			bConfig=1
			shift
		;;
		data)
			bCmd=1
			bData=1
			shift
			scriptOption0="$1"
			shift
			if [ "$scriptOption0" == "enable" ]; then
			    bEnable=1
			else 
			    bDisable=1
			fi
		;;
		gnss|gps)
			bCmd=1
			bGnss=1
			shift
			scriptOption0="$1"
			shift
			if [ "$scriptOption0" == "enable" ]; then
			    bEnable=1
			else 
			    bDisable=1
			fi
		;;
		*)
			echo "ERROR: Invalid Argument: $1"
			usage
			exit
		;;
	esac
done


########################################
########################################
###     Main Program
########################################

## json init
_Init

## commands
if [ $bCmd == 1 ]; then
    if [ $bSetApn == 1 ]; then
        setApn "$scriptOption0"
    elif [ $bData == 1 ]; then
        if [ $bEnable == 1 ]; then
            lteEnable
        elif [ $bDisable == 1 ]; then
            lteDisable
        fi
    elif [ $bGnss == 1 ]; then
        if [ $bEnable == 1 ]; then
            gnssEnable
        elif [ $bDisable == 1 ]; then
            gnssDisable
        fi
    elif [ $bConfig == 1 ]; then
        setupConfig
    fi
    
    if [ $bError == 0 ]; then
        _Print "> Done"
    fi
else
	usage
fi


## json finish
_Close