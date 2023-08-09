#!/bin/sh

## internal functions ##
# check if pwm module is installed
_isPwmAvailable () {
	if [ -d "/sys/class/pwm/pwmchip0" ]; then
		return 0
	else
		return 1
	fi
}

# check if channel is valid
# $1 - channel
_isPwmChannelValid () {
	case "$1" in
		0|1|2|3)
			return 0
		;;
		*)
			return 1
		;;
	esac
}

## External functions ##
# usage
pwmUsage () {
	echo "Configure PWM Channel:"
	echo "	onion [OPTIONS] pwm <CHANNEL> <DUTY CYCLE> <FREQUENCY>"
	echo "		Set PWM Channel to PWM signal with specified duty cycle and frequency"
	echo "			CHANNEL     - can be 0 (GPIO18), 1 (GPIO19), 2 (GPIO 20, Omega2S only), or 3 (GPIO 21, Omega2S only)"
	echo "			DUTY CYCLE  - percentage, expressed 0 - 100"
	echo "			FREQUENCY   - signal frequency, expressed in Hz"
	echo ""
	echo "	onion [OPTIONS] pwm <CHANNEL> disable"
	echo "		Disable the specified PWM Channel"
	echo ""
}

# check if input is valid
#	$1	- channel
checkPwmValid () {
    local channel="$1"
    # check if pwm kernel module is installed
    _isPwmAvailable
    if [ $? -ne 0 ]; then
        echo "ERROR: PWM functionality not available"
        echo "  ensure your Omega is on the latest firmware and run:"
        echo "    opkg update"
        echo "    opkg install kmod-pwm-mediatek-ramips"
        return 1
    fi
    # check if channel is valid
    _isPwmChannelValid "$channel"
    if [ $? -ne 0 ]; then
        echo "ERROR: expecting channel value 0, 1, 2, or 3"
        pwmUsage
        return 1
    fi
    return 0
}

# set a PWM channel to a duty cycle and frequency
#	$1	- channel
#	$2	- duty cycle
#	$3	- frequency
setPwmChannel () {
    # echo "setting channel $1 to $2 duty cycle at $3 frequency"
	local period=$(echo "1/$3 * 1000000000" | bc -l)
	local pulseWidth=$(echo "$period * $2 / 100" | bc -l)
	period=$(echo "scale=0; $period/1" | bc -l)
	pulseWidth=$(echo "scale=0; $pulseWidth/1" | bc -l)
	# echo "period = $period"
	# echo "pulseWidth = $pulseWidth"

	# set the PWM
	echo "$1" > /sys/class/pwm/pwmchip0/export

	echo "$period" > /sys/class/pwm/pwmchip0/pwm$1/period
	echo "$pulseWidth" > /sys/class/pwm/pwmchip0/pwm$1/duty_cycle

	echo "1" > /sys/class/pwm/pwmchip0/pwm$1/enable

	echo "$1" > /sys/class/pwm/pwmchip0/unexport
}

# disable PWM channel output
#	$1	- channel
disablePwmChannel () {
    # echo "disabling channel $1"
	# disable the PWM chanel
	echo "$1" > /sys/class/pwm/pwmchip0/export
	echo "0" > /sys/class/pwm/pwmchip0/pwm$1/enable
	echo "$1" > /sys/class/pwm/pwmchip0/unexport
}