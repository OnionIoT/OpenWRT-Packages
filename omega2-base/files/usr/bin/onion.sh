#!/bin/sh

LIB_PATH="/usr/lib"

bVerbose=0
bPwmCommands=0

if [ -e $LIB_PATH/onion-pwm-lib.sh ]; then
    bPwmCommands=1
    . $LIB_PATH/onion-pwm-lib.sh
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

	echo ""
	echo "Command Line Options:"
	echo "  -v      Increase output verbosity"
	# echo "  -j      Set all output to JSON"
	#echo "  -ap     Set any commands above to refer to an AP network"
	#echo "  -b64    Input arguments are base64 encoded"
	echo ""
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
			shift
			channel="$1"
            checkPwmValid "$channel"
            if [ $? -eq 0 ]; then
                shift 
			    if [ "$1" == "disable" ]; then
                    disablePwmChannel "$channel"
                else
                    # TODO: add check for valid duty cycle and frequency arguments
                    # TODO: clean up how this works - don't like calling these functions in while loop
                    dutyCycle="$1"
                    shift
                    freq="$1"
                    setPwmChannel "$channel" "$dutyCycle" "$freq"
                fi
                shift
            else
                exit 1
            fi
		;;
        *)
			echo "ERROR: Invalid Argument: $1"
			usage
			exit 1
		;;
    esac
done