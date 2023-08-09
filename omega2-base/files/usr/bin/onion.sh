#!/bin/sh

LIB_PATH="/usr/lib"

bVerbose=0
bPwmCommands=0
bTimeCommands=0

ret=1

if [ -e $LIB_PATH/onion-pwm-lib.sh ]; then
    bPwmCommands=1
    . $LIB_PATH/onion-pwm-lib.sh
fi
if [ -e $LIB_PATH/onion-time-lib.sh ]; then
    bTimeCommands=1
    . $LIB_PATH/onion-time-lib.sh
fi

## Usage
usage () {
	echo "Functionality:"
	echo "	Configure Onion products"
	echo ""

	echo "General Usage:"
	echo "	onion [OPTIONS] <COMMAND> <PARAMETER>"
	echo ""

    if [ $bPwmCommands -eq 1 ]; then
        pwmUsage
    fi
    if [ $bTimeCommands -eq 1 ]; then
        timeUsage
    fi

	echo ""
	echo "Command Line Options:"
	echo "  -v      Increase output verbosity"
	# echo "  -j      Set all output to JSON"
	#echo "  -ap     Set any commands above to refer to an AP network"
	#echo "  -b64    Input arguments are base64 encoded"
	echo ""
}

# Function to handle PWM operations
handlePwmOperation() {
    local channel="$1"
    shift
    checkPwmValid "$channel"
    if [ $? -ne 0 ]; then
        return 1
    fi

    if [ "$1" == "disable" ]; then
        disablePwmChannel "$channel"
    else
        # TODO: add check for valid duty cycle and frequency arguments
        local dutyCycle="$1"
        shift
        local freq="$1"
        setPwmChannel "$channel" "$dutyCycle" "$freq"
    fi
    return 0
}

# Function to handle time operations
handleTimeOperation() {
    local command="$1"
    shift

    if [ "$command" == "list" ]; then
        listTimezones
    elif [ "$command" == "sync" ]; then
        syncTime
    elif [ "$command" == "set" ]; then
        local timezone="$1"
        shift
        local tz="$1"
        # TODO: add check for valid arguments
        setTimezone "$timezone" "$tz"
    else
        return 1
    fi
    return 0
}

# parse arguments
while [ "$1" != "" ]
do
    case "$1" in
        # options
        -v|--v|-verbose|verbose)
            bVerbose=1
            shift
            ;;
        # commands
        pwm)
            if [ $bPwmCommands -eq 1 ]; then
                shift
                handlePwmOperation "$@"
                ret=$?
                break
            else
                $2="error"
            fi
            shift
            ;;
        time)
            if [ $bTimeCommands -eq 1 ]; then
                shift
                handleTimeOperation "$@"
                ret=$?
                break
            else
                $2="error"
            fi
            shift
            ;;
        # catch error
        *)
            echo "ERROR: Invalid Argument: $1"
            usage
            exit 1
            ;;
    esac
done

exit $ret