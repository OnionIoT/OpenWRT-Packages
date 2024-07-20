#! /bin/sh

## script to interact with the Power Dock 2

# global variables
bUsage=0
bJson=0
bReportPercentage=0
progLoop=0

VbattMax=4.20

Usage () {
	echo ""
	echo "Usage: power-dock"
	echo ""
	echo "FUNCTIONALITY:"
	echo "Onion Power Dock 2: enables the Battery Level Indicator LEDs and outputs the battery voltage"
	echo ""
	echo "OPTIONS:"
	echo " -l <TIME>	Repeatedly report battery level,"
	echo "   		with <TIME> seconds between each report"
	echo " -p 		Show battery percentage as well"
	echo " -j 		json output"
	echo " -h 		help: show this prompt"
	echo ""
}

# find voltage measurement from ADC
getRawBatteryVoltage() {
	# find the ADC measurement
	local adc=$(($(i2cget -y 0 0x4d 0x00 w | sed -e 's/0x\(..\)\(..\)/0x\2\1/')/4))
	#echo $adc

	local Ain=$(echo "($adc/1024)*(3.3)" | bc -l)
	#echo $Ain

	local Vbatt=$(echo "$Ain*5/4" | bc -l)
	echo "$Vbatt"
}

# return battery voltage measurement with 2 decimal points
getBatteryVoltage() {
	local Vbatt=$(getRawBatteryVoltage)
	local VbattRounded=$(echo "scale=2; $Vbatt/1" | bc -l)

	echo "$VbattRounded"
}

# return battery percentage out of VbattMax
getBatteryPercentage() {
	local Vbatt=$(getRawBatteryVoltage)

	local battDecimal=$(echo "scale=2; $Vbatt/$VbattMax" | bc -l)
	local battPercent=$(echo "$battDecimal * 100" | bc -l)
	battPercent=$(echo "scale=0; $battPercent / 1" | bc -l)

	echo "$battPercent"
}

# read and report battery level
reportBatteryLevel() {
	# read the battery level
	local VbattRounded=$(getBatteryVoltage)
	if [ $bReportPercentage -ne 0 ]; then
		local battPercent=$(getBatteryPercentage)
	fi

	# enable the battery LEDs
	/usr/bin/power-dock -q2

	# print output
	if [ $bJson == 1 ]; then
		echo -n "{\"voltage\":$VbattRounded"
		if [ $bReportPercentage -ne 0 ]; then
			echo ", \"percent\":$battPercent}"
		else
			echo "}"
		fi
	else
		echo "Battery Voltage Level: $VbattRounded V"
		if [ $bReportPercentage -ne 0 ]; then
			echo "Battery Level Percent: $battPercent %"
		fi
	fi
}


### MAIN PROGRAM ###
# parse arguments
while [ "$1" != "" ]
do
    case "$1" in
		-l|--l|loop|-loop|--loop)
			shift
            progLoop="$1"
            shift
        ;;
		-p|--p|percent|-percent|--percent)
            bReportPercentage=1
            shift
        ;;
        -h|--h|help|-help|--help)
            bUsage=1
            shift
        ;;
        -j|--j|json|-json|--json)
            bJson=1
            shift
        ;;
        *)
            echo "ERROR: Invalid Argument: $1"
            shift
            exit
        ;;
    esac
done


# print usage and exit
if [ $bUsage == 1 ]; then
    Usage
    exit
fi

if [ $progLoop -eq 0 ]; then
	## normal operation - read value once then exit
	reportBatteryLevel
else
	## loop operation - infinite loop to report battery level
	##		time between reports is specified by progLoop (seconds)
	while [ 1 ]; do
		reportBatteryLevel
		sleep $progLoop
	done
fi
