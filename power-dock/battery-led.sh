#!/bin/sh

### 
# Simple script to test Power Dock battery indicator
#
# Requires additional package:
#	opkg install coreutils-sleep
###



IC_CTRL_GPIO=19
IC_CTRL_SLEEP="0.1"
BL0_GPIO=18
BL1_GPIO=16
PLUGDETECT_GPIO=15

ActivateBatteryLevel () {
	echo "> Pulse"
	gpioctl dirout-high $IC_CTRL_GPIO >& /dev/null
	/usr/bin/sleep $IC_CTRL_SLEEP
	gpioctl dirout-low $IC_CTRL_GPIO >& /dev/null
}

ReadGpio () {
	val=$(gpioctl get $1 | grep LOW)

	if [ "$val" != "" ]; then
		ret="0"
	else
		ret="1"
	fi

	echo "$ret"
}

CheckBatteryLevel () {
	charge=$(ReadGpio $PLUGDETECT_GPIO)
	echo "> Charging status: $charge"

	battery1=$(ReadGpio $BL1_GPIO)
	battery0=$(ReadGpio $BL0_GPIO)
	echo "> Battery Level: $battery0 $battery1"
}

echo "> Enabling Battery LEDs"

#while [ 1 ]
#do
#       gpioctl dirout-low $IC_CTRL_GPIO
#       /usr/bin/sleep $IC_CTRL_SLEEP
#       gpioctl dirout-high $IC_CTRL_GPIO
#
#       /usr/bin/sleep 0.1
#done

# gpio setup
gpioctl dirin $BL0_GPIO >& /dev/null
gpioctl dirin $BL1_GPIO >& /dev/null
gpioctl dirin $PLUGDETECT_GPIO >& /dev/null

ActivateBatteryLevel

/usr/bin/sleep 0.5
CheckBatteryLevel

/usr/bin/sleep 1
echo "> Next battery check"
CheckBatteryLevel

