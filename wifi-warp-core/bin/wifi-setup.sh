#!/bin/sh

## script to setup uci wireless configuration for use with wifimanager utility

. /usr/share/libubox/jshn.sh


### global variables
# options
bVerbose=0
bJson=0
bBase64=0
bError=0

#commands
bCmd=0
bCmdAdd=0
bCmdEdit=0
bCmdDisable=0
bCmdEnable=0
bCmdRemove=0
bCmdClear=0     # for clearing saved network entries
bCmdReset=0     # for overwriting wireless config with factory file
bCmdPriority=0
bCmdList=0
bCmdInfo=0


#parameters
bApNetwork=0


#############################
##### Print Usage ###########
usage () {
	_Print "Functionality:"
	_Print "	Configure WiFi networks on the Omega"
	_Print ""

	_Print "Interactive Usage:"
	_Print "$0"
	_Print "	Accepts user input"
	_Print ""
	_Print ""

	_Print "Command Line Usage:"
	_Print "$0 [options] <command> <parameters>"
	_Print ""
	_Print ""
	_Print "Available Commands:"
	_Print "  add "
	_Print "Functionality: Add a new WiFi network to the Omega's settings"
	_Print "Usage: $0 add -ssid <ssid> -encr <encryption type> -password <password>"
	_Print "Valid encryption types [psk2, psk, wep, none]"
	_Print ""
	_Print "  edit "
	_Print "Functionality: Edit the information of a configured WiFi network"
	_Print "Usage: $0 edit -ssid <ssid> -encr <encryption type> -password <password>"
	_Print ""
	_Print "  remove "
	_Print "Functionality: Remove an existing WiFi network from the Omega's settings"
	_Print "Usage: $0 remove -ssid <ssid>"
	_Print ""
	_Print "  priority "
	_Print "Functionality: Move a WiFi network up or down in the priority list when attempting to connect"
	_Print "Usage: $0 priority -ssid <ssid> -move <up|down>"
	_Print "           up:     increase the priority"
	_Print "           down:   decrease the priority"
	_Print "           top:    make highest priority network"
	_Print ""
	_Print "  list "
	_Print "Functionality: Display a JSON-formatted list of all configured networks"
	_Print "Usage: $0 list"
	_Print ""
	_Print "  info "
	_Print "Functionality: Display a JSON-formatted table of all info for specified network"
	_Print "Usage: $0 info -ssid <ssid>"
	_Print ""
	_Print "  clear "
	_Print "Functionality: Clear all saved network configurations"
	_Print "Usage: $0 clear"
	_Print ""
	#_Print "  reset "
	#_Print "Functionality: Completely reset wireless network configuration to factory settings"
	#_Print "Usage: $0 reset"
	#_Print ""

	_Print ""
	_Print "Command Line Options:"
	_Print "  -v      Increase output verbosity"
	_Print "  -j      Set all output to JSON"
	_Print "  -ap     Set any commands above to refer to an AP network"
	_Print "  -b64    Input arguments are base64 encoded"
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

# decode a base64 encoded string
#	$1	- base64 encoded string
#	returns decoded string
_base64Decode () {
	local string="$1"
	string=$(echo "$string" | base64 -d)
	echo "$string"
}


########################################
###     UCI Searching Functions
########################################

# find total number of configured wifi networks
# 	returns value via echo
_FindNumNetworks () {
	local count=0

	# find the first network
	local network=$(uci -q get wireless.\@wifi-config[$count])

	# loop through all configured networks
	while [ "$network" == "wifi-config" ]
	do
		# add to the count
		count=$(($count + 1))

		# continue the loop
		network=$(uci -q get wireless.\@wifi-config[$count])
	done

	# return the count number
	echo $count
}

# find a network's array number by the ssid
#	$1	- ssid to look for
#	returns value via echo
#		-1: 		if not found
#		all others: valid value found
_FindNetworkBySsid () {
	local id=-1
	local count=0
	local ssidKey="$1"

	# ensure argument is present
	if [ "$ssidKey" != "" ]; then

		# find the first network
		local network=$(uci -q get wireless.\@wifi-config[$count])

		# loop through all configured networks
		while [ "$network" == "wifi-config" ]
		do
			# find the ssid
			local ssid=$(uci -q get wireless.\@wifi-config[$count].ssid)

			if [ "$ssid" == "$ssidKey" ]; then
				id=$count
				break
			fi

			# continue the loop
			count=$(($count + 1))
			network=$(uci -q get wireless.\@wifi-config[$count])
		done
	fi

	# return the count number
	echo $id
}

# find a networks SSID from the id
#	returns value via echo
#	$1	- network id
_FindNetworkSsid () {
	if [ $bApNetwork == 1 ]; then
		local ssidName=$(uci -q get wireless.\@wifi-iface[$1].ssid)
		#local ssidName=$(uci -q get wireless.ap.ssid)	# confirm the fix
	else
		local ssidName=$(uci -q get wireless.\@wifi-config[$1].ssid)
	fi

	echo $ssidName
}


########################################
###     UCI Interaction Functions
########################################

# commit changes to wireless config
UciCommitWireless () {
	uci commit wireless
}

# add a wireless.wifi-config section
UciAddWifiConfigSection () {
	uci add wireless wifi-config > /dev/null
}

# get a wireless.wifi-config section based on it's index number
#  input:
#	$1	- index
#  output:
#	if section found: 	"wifi-config"
#	no section found:	""
UciCheckWifiConfigIndex () {
	local index=$1
	local config=""

	if [ $index -ge 0 ]; then
		config=$(uci -q get wireless.\@wifi-config[$index])
	fi

	echo "$config"
}

# populate a wireless.wifi-config section
#  input:
#	$1	- index
#	$2	- ssid
#	$3	- encryption
#	$4	- password
#	$5	- bssid (optional)
UciPopulateWifiConfigSection () {
	local index="$1"
	local ssid="$2"
	local encryption="$3"
	local password="$4"
	local bssid="$5"

	# set the network key based on the encryption
	case "$encryption" in
		psk2|psk)
			uci set wireless.\@wifi-config[$index].key="$password"
		;;
		wep)
			uci set wireless.\@wifi-config[$index].key=1
			uci set wireless.\@wifi-config[$index].key1="$password"
		;;
		none|*)
			# add a 'NONE' value as a placeholder for open networks
			# the config parser in wifimanager expects non-empty values for existing configurations
			uci set wireless.\@wifi-config[$index].key='none'
		;;
	esac

	# set the ssid and encryption type
	uci set wireless.\@wifi-config[$index].ssid="$ssid"
	uci set wireless.\@wifi-config[$index].encryption="$encrypt"

	# set the bssid
	if [ "$bssid" != "" ]; then
		uci set wireless.\@wifi-config[$index].bssid="$bssid"
	fi

	# commit the changes
	UciCommitWireless
	# TODO: ensure the above is required
}

# delete a wireless.wifi-config section
#  input:
#	$1	- index
#	$2	- ssid
UciDeleteWifiConfigSection () {
	local index=$1
	local ssid=$2

	# remove the section
	uci delete wireless.\@wifi-config[$index]
	# commit the changes
	UciCommitWireless
}

# reorder a wireless.wifi-config section
#  input:
#	$1	- index
#	$2	- ssid
#	$3	- desired order number in uci config
# 	$4 	- priority number in terms of other networks (optional)
UciReorderWifiConfigSection () {
	local index=$1
	local ssid=$2
	local priority=$3
	local humanPriority=$4

	# check that this wifi-config exists
	local config=$(UciCheckWifiConfigIndex $index)

	if [ "$config" != "" ]; then
		# print a message
		if [ "$humanPriority" != "" ]; then
			_Print "> Shifting '$ssid' priority to $humanPriority" "output"
		else
			_Print "> Shifting '$ssid' priority" "output"
		fi

		# perform the reorder
		uci reorder wireless.\@wifi-config[$index]=$priority

		# commit the changes
		UciCommitWireless
	fi
}

# output a JSON object of specified network
#	$1 	- network id
#	$2	- ssid
UciJsonOutputWifiNetworkInfo () {
	local id=$1
	local ssid=$2
	local connectedNetwork=""
	local staDisabled="1"

	# find the currently connected network
	staDisabled=$(UciGetWifiIfaceDisabled "sta")
	if [ "$staDisabled" == "0" ]; then
		connectedNetwork=$(UciGetWifiIfaceOption "sta" "ssid")
	fi

	# check that this wifi-config exists
	local config=$(UciCheckWifiConfigIndex $id)

	if [ "$config" != "" ]; then
		# find the data
		local ssidRd=$(uci -q get wireless.\@wifi-config[$id].ssid)
		local modeRd=$(uci -q get wireless.\@wifi-config[$id].mode)
		local encrRd=$(uci -q get wireless.\@wifi-config[$id].encryption)
		local authRd=$(uci -q get wireless.\@wifi-config[$id].authentication)
		local passwordRd=$(uci -q get wireless.\@wifi-config[$id].key)
		local bssidRd=$(uci -q get wireless.\@wifi-config[$id].bssid)

		# check if this network is currently connected
		if [ "$connectedNetwork" == "$ssidRd" ]; then
			json_add_boolean "enabled" 1
		else
			json_add_boolean "enabled" 0
		fi

		if [ "$encrRd" == "wep" ]; then
			passwordRd=$(uci -q get wireless.\@wifi-config[$id].key$passwordRd)
		fi

		# create and populate object for this network
		_Print "$ssidRd" "ssid"
		_Print "$encrRd" "encryption"
		_Print "$passwordRd" "password"

		if [ "$bssidRd" != "" ]; then
			_Print "$bssidRd" "bssid"
		fi
	else
		$bError=1
	fi
}

# output a JSON list of all configured networks
UciJsonOutputAllNetworks () {
	local count=0

	# create the results array
	json_add_array results

	# find the first network
	local config=$(UciCheckWifiConfigIndex $count)

	# loop through all configured networks
	while [ "$config" == "wifi-config" ]
	do
		# create an object for this network
		json_add_object
		# populate the object
		UciJsonOutputWifiNetworkInfo $count
		# close the object
		json_close_object

		# continue the loop
		count=$(($count + 1))
		config=$(UciCheckWifiConfigIndex $count)
	done

	# finish the array
	json_close_array

	# print the json
	if [ $bJson == 0 ]; then
		json_dump | sed 's/,/,\n       /g' | sed 's/{ "/{\n\n        "/g' | sed 's/}/\n\}/g' | sed 's/\[/\[\n/g' | sed 's/\]/\n\]/g'
	fi
}

# output a JSON object of AP network
UciJsonOutputWifiApInfo () {
	# create the results array
	json_add_array results
	# create an object for the AP network
	json_add_object

	## populate with AP info
	# find the data
	local ssidRd=$(uci -q get wireless.ap.ssid)
	local modeRd=$(uci -q get wireless.ap.mode)
	local encrRd=$(uci -q get wireless.ap.encryption)
	local authRd=$(uci -q get wireless.ap.authentication)
	local passwordRd=$(uci -q get wireless.ap.key)
	local bDisabledRd=$(uci -q get wireless.ap.disabled)
	local ipAddr=$(uci -q get network.wlan.ipaddr)

	if [ "$bDisabledRd" == "0" ]; then
		json_add_boolean "enabled" 1
	else
		json_add_boolean "enabled" 0
	fi

	if [ "$encrRd" == "wep" ]; then
		passwordRd=$(uci -q get wireless.ap.key$passwordRd)
	fi

	# create and populate object for this network
	_Print "$ssidRd" "ssid"
	_Print "$encrRd" "encryption"
	_Print "$passwordRd" "password"
	_Print "$ipAddr" "ip"

	# close the object
	json_close_object
	# close the array
	json_close_array

	# print the json
	if [ $bJson == 0 ]; then
		json_dump | sed 's/,/,\n       /g' | sed 's/{ "/{\n\n        "/g' | sed 's/}/\n\}/g' | sed 's/\[/\[\n/g' | sed 's/\]/\n\]/g'
	fi
}


### wifi-iface ###

# check wifi-iface interface input
#	$1 	- 'ap' or 'sta'
UciCheckWifiIfaceInput () {
	local iface=$1
	local bIfaceError=0

	# check if iface is an allowed input
	if 	[ "$iface" != "ap" ] &&
		[ "$iface" != "sta" ];
	then
		bIfaceError=1
	fi

	echo $bIfaceError
}

# enable or disable a wifi iface
#	$1 	- 'ap' or 'sta'	(assuming that this has been checked)
#	$2	- enable (1) or disable (0)
UciSetWifiIfaceEnable () {
	local iface=$1
	local bEnable=$2

	# wifi-iface needs 'disabled' parameter - invert the enable
	local bDisabled=$((!$bEnable))

	# set the enable/disable
	uci set wireless.$iface.disabled="$bDisabled"

	# commit the changes
	UciCommitWireless
	# TODO: ensure the above is required
}

# set wifi-device mode
#
UciSetWifiDeviceMode () {
	local mode="$1"

	# set the device mode
	uci set wireless.radio0.device_mode="$mode"

	# commit the changes
	UciCommitWireless
}

# populate a wireless.wifi-config section
#  input:
#	$1	- iface
#	$2	- ssid
#	$3	- encryption
#	$4	- password
UciPopulateWifiIfaceSection () {
	local iface=$1
	local ssid=$2
	local encryption=$3
	local password=$4

	# check if iface is an allowed input
	local bInvalidInput=$(UciCheckWifiIfaceInput $iface)
	if 	[ $bInvalidInput -eq 0 ]; then
		# set the network key based on the encryption
		case "$encryption" in
			psk2|psk)
				uci set wireless.$iface.key="$password"
			;;
			wep)
				uci set wireless.$iface.key=1
				uci set wireless.$iface.key1="$password"
			;;
			none|*)
				# add a 'NONE' value as a placeholder for open networks
				# the config parser in wifimanager expects non-empty values for existing configurations
				uci set wireless.$iface.key='none'
			;;
		esac

		# set the ssid and encryption type
		uci set wireless.$iface.ssid="$ssid"
		uci set wireless.$iface.encryption="$encrypt"

		# commit the changes
		UciCommitWireless
	fi
}

# from a wireless.wifi-iface section, get the value of an option
#  input:
#	$1	- iface
#	$2 	- option
#  output:
#	if section found: 	<option value>
#	no section found:	""
UciGetWifiIfaceOption () {
	local iface=$1
	local option="$2"
	local value=""

	# check if iface is an allowed input
	local bInvalidInput=$(UciCheckWifiIfaceInput $iface)
	if 	[ $bInvalidInput -eq 0 ]; then
		value=$(uci -q get wireless.$iface.$option)
	fi

	echo "$value"
}


# get a wireless.wifi-iface section's 'disabled' option's value
#  input:
#	$1	- iface
#  output:
#	0 or 1
UciGetWifiIfaceDisabled () {
	local iface=$1
	local disabled="1"

	disabled=$(UciGetWifiIfaceOption "$iface" "disabled")

	echo "$disabled"
}




########################################
###     Wifi Network Modification Functions
########################################

# Ensure network key meets length requirements based on the encryption type
#  input:
#	$1	- encryption
#	$2	- password
#  output:
#	if key is ok: 		0
#	if key is not ok:	1
_CheckPasswordLength () {
	local encryption=$1
	local password=$2
	local bKeyError=0

	keyLength=${#password}

	# perform the check
	case "$encryption" in
		psk2|psk)
			if [ "$keyLength" -lt 8 ] ||
				[ "$keyLength" -gt 64 ]; then
				_Print "> ERROR: Password length does not match encryption type. WPA2 passwords must be between 8 and 64 characters." "error"
				bKeyError=1
				exit
			fi
		;;
		wep)
			if [ "$keyLength" -lt 5 ]; then
				_Print "> ERROR: Password length does not match encryption type. Please enter a valid password." "error"
				bKeyError=1
				exit
			fi
		;;
		none|*)
			# nothing
			bKeyError=0
		;;
	esac

	echo $bKeyError
}

# Add a uci section for a wifi network
#	$1 	- interface number	#TODO: likely don't need this LAZAR
#	$2 	- ssid
#	$3	- encryption type
#	$4	- password
#	$5	- bssid (optional)
AddWifiNetwork () {
	local id="$1"
	local ssid="$2"
	local encrypt="$3"
	local password="$4"
	local bssid="$5"
	local bNew=0

	# check the network password
	bError=$(_CheckPasswordLength $encrypt "$password")

	if [ $bError == 0 ]; then
		# add new wifi-config section if required
		local config=$(UciCheckWifiConfigIndex $id)
		if [ "$config" != "wifi-config" ]; then
			UciAddWifiConfigSection
			bNew=1
		fi

		# populate the wifi-config section
		UciPopulateWifiConfigSection $id "$ssid" "$encrypt" "$password" "$bssid"
	fi
}

# Edit a uci section for a wifi network
#	$1 	- interface number	#TODO: likely don't need this LAZAR
#	$2 	- ssid
#	$3	- encryption type
#	$4	- password
#	$5 	- bssid (optional)
EditWifiNetwork () {
	local id=$1
	local ssid=$2
	local encrypt=$3
	local password=$4
	local bssid=$5
	local bNew=0

	# check the network password
	bError=$(_CheckPasswordLength $encrypt "$password")

	# TODO: LAZAR: add a search based on the ssid

	if [ $bError == 0 ]; then
		# add new wifi-config section if required
		local config=$(UciCheckWifiConfigIndex $id)
		if [ "$config" != "wifi-config" ]; then
			_Print "> ERROR: Cannot modify network, it does not exist in the database." "error"
		else
			# populate the wifi-config section
			UciPopulateWifiConfigSection $id "$ssid" "$encrypt" "$password" "$bssid"
		fi
	fi
}

# Enable or Disable a wifi interface
#	$1 	- 'ap' or 'sta'
#	$2	- enable (1) or disable (0)
SetWifiIfaceEnable () {
	local iface=$1
	local bEnable=$2

	# check if iface is an allowed input
	local bInvalidInput=$(UciCheckWifiIfaceInput $iface)
	if 	[ $bInvalidInput -eq 0 ]; then
		UciSetWifiIfaceEnable $iface $bEnable
	fi
}

# Set the device mode
#	$1	- 'ap', 'sta', or 'apsta'
SetWifiDeviceMode () {
	local mode="$1"

	# check if valid input
	if 	[ "$mode" == "ap" ] ||
		[ "$mode" == "sta" ] ||
		[ "$mode" == "apsta" ];
	then
		UciSetWifiDeviceMode "$mode"
	fi
}

# Remove a wifi-config section that defines a wifi network
#	$1 	- interface number	#TODO: likely don't need this LAZAR
#	$2 	- ssid
RemoveWifiNetwork () {
	local id=$1
	local ssid=$2

	# check the argument
	if [ $id -ge 0 ]; then
		# ensure that iface exists
		local config=$(UciCheckWifiConfigIndex $id)
		if [ "$config" == "wifi-config" ]; then
			_Print "> Removing '$ssid' network from database" "output"
			UciDeleteWifiConfigSection $id "$ssid"
		fi
	fi
}

# change the priority of a network (by changing the uci wireless section order)
#	$1 	- network section id
#	$2	- network ssid
#	$3 	- argument for moving the network
SetWifiNetworkPriority () {
	local id=$1
	local ssid=$2
	local argument=$3

	#### wireless config file breakdown:
	##	SECTION 					order
	##	wireless.radio0				0
	##	wireless.ap					1
	##	wireless.sta				2
	##	wireless.@wifi-config[0]	3		- highest priority for a network
	##	wireless.@wifi-config[n]	n+3		- lowest priority for a network

	# define the highest priority
	local topPriority=3
	# find the lowest priority
	local bottomPriority=$(($(_FindNumNetworks) - 1  + $topPriority))
	# find the network's current priority
	local currPriority=$(($id + $topPriority))

	# find the shift in priority
	if [ "$argument" == "up" ]; then
		desiredPriority=$(($currPriority - 1))
	elif [ "$argument" == "down" ]; then
		desiredPriority=$(($currPriority + 1))
	elif [ "$argument" == "top" ]; then
		desiredPriority=$topPriority
	fi

	## find the new human-readable priority
	local hmnPriority=$(($desiredPriority - $topPriority))

	# check that shift is valid
	if 	[ $desiredPriority -lt $topPriority ] ||
		[ $desiredPriority -gt $bottomPriority ] ||
		[ $currPriority -lt $topPriority ];
	then
		_Print "> ERROR: Invalid priority shift requested" "error"
		_SetError
	else
		UciReorderWifiConfigSection $id "$ssid" $desiredPriority $hmnPriority
	fi
}

# clear all configured wifi networks
ClearAllWifiNetworks () {
	_Print "Clearing all stored network entries." "info"
	local count=0

	# find the first network
	local config=$(UciCheckWifiConfigIndex $count)

	# loop through all configured networks
	while [ "$config" == "wifi-config" ]
	do
		# remove the network
		UciDeleteWifiConfigSection $count

		# grab the next configured network
		# 	don't increment count, loop will exit when there are no more networks left
		config=$(UciCheckWifiConfigIndex $count)
	done

	# reset the STA paramters and disable it
	UciPopulateWifiIfaceSection "sta" "yourssid" "psk2" "yourpassword"
	UciSetWifiIfaceEnable "sta" 0

	_Print "Restarting WiFi driver and disconnecting from current network."
	_Print "This will end all wireless ssh sessions!"

	# reset the wifi adapter with the new settings
	wifi
}

# reset all wireless and network settings to that of factory
ResetNetworkSettings () {
	_Print "Reseting all wireless network settings to factory state." "info"

	cp /rom/etc/config/wireless /etc/config/wireless
	cp /rom/etc/config/network /etc/config/network

	# find the hostname
	local name=$(uci -q get system.\@system[0].hostname)
	uci set wireless.ap.ssid="$name"
	UciCommitWireless

	_Print "Restarting WiFi driver and disconnecting from current network."
	_Print "This will end all wireless ssh sessions!"

	# reset the wifi adapter with the new settings
	wifi
}



########################################
###     User Input Functions
########################################

# Normalize the authentication input
#	modifies the global auth variable
_NormalizeEncryptInput () {
	case "$encrypt" in
		WPA1PSKWPA2PSK|WPA2PSK|wpa2|psk2|WPA2|PSK2|wpa-mixed)
			encrypt="psk2"
		;;
		WPA1PSK|wpa|psk|WPA|PSK)
			encrypt="psk1"
		;;
		wep|WEP)
			encrypt="wep"
		;;
		none|*)
			encrypt="none"
		;;
	esac
}

# read WPA settings from json data
# TODO: find out if this is still needed
_UserInputJsonReadNetworkAuthPsk () {
	local bFoundType1=0
	local bFoundType2=0
	local type=""

	# check the wpa object
	json_get_type type wpa

	# read the wpa object
	if [ "$type" == "array" ]
	then
		# select the wpa object
		json_select wpa

		# find all the values
		json_get_values values

		# read all elements
		for value in $values
		do
			# parse value
			if [ $value == 1 ]
			then
				bFoundType1=1
			elif [ $value == 2 ]
			then
				bFoundType2=1
			fi
		done

		# return to encryption object
		json_select ..

		# select the authentication type based on the wpa values that were found
		if [ $bFoundType1 == 1 ]
		then
			auth="psk"
		fi
		if [ $bFoundType2 == 1 ]
		then
			# wpa2 overrides wpa
			auth="psk2"
		fi

	fi
}

# read network encryption type from json data from iwinfo scan
_UserInputJsonReadNetworkAuth () {
	# select the encryption object
	local index=$1
	json_load "$RESP"

	json_get_type type results

	json_select results
	json_get_keys keys

	# read the wifi scan object object
	if 	[ "$type" == "array" ] &&
		[ "$keys" != "" ];
	then
		# select the specific wifi network
		json_select $index

		# read the authentication object type
		# json_get_var auth_type encryption # old backwards mapping
		json_get_var encrypt encryption
	else
		# results object is not an array and there are no keys
		# OLD COMMENT: no encryption: open network
		encrypt="none"
	fi
}

# manually read network authentication from user
_UserInputReadNetworkAuth () {
    # present user with authentication options
	echo ""
	echo "Select network authentication type:"
	echo "1) WPA2"
	echo "2) WPA"
	echo "3) WEP"
	echo "4) None"
	echo ""
	echo -n "Selection: "
	read input


    # assume default encryption type for all authentication modes
	case "$input" in
		1)
			encrypt="psk2"
		;;
		2)
			encrypt="psk"
		;;
		3)
			encrypt="wep"
		;;
		4)  # no encryption, no key
			encrypt="none"
			key="none"
		;;
	esac
}


# scan wifi networks, display for user, allow them to pick one
#	when function completes successfully, the following global variables will be populated:
#	* ssid
#	* encrypt
_UserInputScanWifi () {
	# run the scan command and get the response
	RESP=$(ubus call onion wifi-scan '{"device":"ra0"}')

	# read the json response
	json_load "$RESP"

	# check that array is returned
	json_get_type type results

	# find all possible keys
	json_select results
	json_get_keys keys


	if 	[ "$type" == "array" ] &&
		[ "$keys" != "" ];
	then
		echo ""
		echo "Select Wifi network:"

		# loop through the keys
		for key in $keys
		do
			# select the array element
			json_select $key

			# find the ssid
			json_get_var cur_ssid ssid
			if [ "$cur_ssid" == "" ]
			then
				cur_ssid="[hidden]"
			fi
			echo "$key) $cur_ssid"

			# return to array top
			json_select ..
		done

		# read the input
		echo ""
		echo -n "Selection: "
		read input;

		# get the selected ssid
		json_select $input
		json_get_var ssid ssid

		if [ "$ssid" == "" ]; then
			_Print "> ERROR: specified ssid not in the database" "error"
			bError=1
			exit
		fi
		echo "Network: $ssid"

		# detect the authentication type
		_UserInputJsonReadNetworkAuth "$input"

		#echo "Authentication type: $auth"

		# print encryption type
		echo "Encryption type: $encrypt"
	else
		wifi
		bScanFailed=1
		echo "> ERROR: Scan failed, try again"
	fi
}

# main function to read user input
#	when function completes successfully, the following global variables will be populated:
#	* ssid
#	* encrypt
#	* password
_UserInputMain () {
	bScanFailed=0
	echo "Onion Omega Wifi Setup"
	echo ""
	echo "Select from the following:"
	echo "1) Scan for Wifi networks"
	echo "2) Type network info"
	echo "q) Exit"
	echo ""
	echo -n "Selection: "
	read input

	# choice between scanning
	if [ $input == 1 ]
	then
		# perform the scan and select network
		echo "Scanning for wifi networks..."
		_UserInputScanWifi

	elif [ $input == 2 ]
	then
		# manually read the network name
		echo -n "Enter network name: "
		read ssid;

		# read the authentication type
		_UserInputReadNetworkAuth
	else
		echo "Bye!"
		exit
	fi

	# read the network password
	if 	[ "$encrypt" != "none" ] &&
		[ $bScanFailed == 0 ];
	then
		echo -n "Enter password: "
		read password
	fi

	echo ""
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
		-ap|--ap|accesspoint|-accesspoint|--accesspoint)
			bApNetwork=1
			shift
		;;
		-b64|--b64|-base64|--base64|base64)
			bBase64=1
			shift
		;;
		# commands
		-add|add)
			bCmd=1
			bCmdAdd=1
			shift
		;;
		-edit|edit)
			bCmd=1
			bCmdEdit=1
			shift
		;;
		-disable|disable)
			bCmd=1
			bCmdDisable=1
			shift
		;;
		-enable|enable)
			bCmd=1
			bCmdEnable=1
			shift
		;;
		-remove|remove)
			bCmd=1
			bCmdRemove=1
			shift
		;;
		-priority|priority)
			bCmd=1
			bCmdPriority=1
			shift
		;;
		-list|list)
			bCmd=1
			bCmdList=1
			bJson=1
			shift
		;;
		-info|info)
			bCmd=1
			bCmdInfo=1
			bJson=1
			shift
		;;
		-clear|clear)
			bCmd=1
			bCmdClear=1
			shift
		;;
		-reset|reset)
			bCmd=1
			bCmdReset=1
			shift
		;;
		-h|--h|help|-help|--help)
			usage
			exit
		;;
		# parameters
		-ssid|ssid)
			shift
			ssid="$1"
			shift
		;;
		-password|password)
			shift
			password="$1"
			shift
		;;
		-encr|encr)
			shift
			encrypt="$1"
			shift
		;;
		-move|move)
			shift
			priorityMove=$1
			shift
		;;
		-bssid|bssid)
			shift
			bssid="$1"
			shift
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

## user input ##
if [ $bCmd == 0 ]; then
	# grab input from the user
	_UserInputMain
	# now globals ssid, encrypt, and password are populated

	# enable the add command if user input was successful (ssid and auth are defined)
	if 	[ "$ssid" != "" ] &&
		[ "$encrypt" != "" ];
	then
		bCmdAdd=1
	fi
fi


## json init
_Init

# base64 decode of parameter arguments
if [ $bBase64 == 1 ]; then
	ssid=$(_base64Decode "$ssid")
	password=$(_base64Decode "$password")
	encrypt=$(_base64Decode "$encrypt")
	priorityMove=$(_base64Decode "$priorityMove")
	bssid=$(_base64Decode "$bssid")
fi

## parameter processing
if [ $bApNetwork == 1 ]; then
	networkType="ap"
	id="ap"
else
	networkType="sta"
	# check if network already exists in configuration
	id=$(_FindNetworkBySsid "$ssid")
fi

if [ "$encrypt" != "" ]; then
	_NormalizeEncryptInput
fi



## commands
if [ $bCmdAdd == 1 ]; then
	# if it doesn't already exist, add a new section
	if [ $id == -1 ]; then
		id=$(_FindNumNetworks)
	fi

	# add the network entry
	AddWifiNetwork $id "$ssid" "$encrypt" "$password" "$bssid"
	# enable the sta interface
	UciSetWifiIfaceEnable "sta" 1
	# set device mode to enable sta
	SetWifiDeviceMode "apsta"

elif [ $bCmdEdit == 1 ]; then
	if [ $bApNetwork == 1 ]; then
		# edit the ap network
		UciPopulateWifiIfaceSection "$networkType" "$ssid" "$encrypt" "$password"
		bCmdAdd=1	# ensure wifi gets called to make sure changes get applied
	else
		# edit the network entry
		EditWifiNetwork $id "$ssid" "$encrypt" "$password" "$bssid"
	fi

elif [ $bCmdDisable == 1 ]; then
	# disable the network
	SetWifiIfaceEnable $networkType 0

elif [ $bCmdEnable == 1 ]; then
	# enable the network
	SetWifiIfaceEnable $networkType 1

elif [ $bCmdRemove == 1 ]; then
	# only remove existing networks
	if [ $id != -1 ]; then
		RemoveWifiNetwork $id "$ssid"
	fi

elif [ $bCmdPriority == 1 ]; then
	# only move existing network
	if [ $id != -1 ]; then
		SetWifiNetworkPriority $id "$ssid" "$priorityMove"
	fi

elif [ $bCmdList == 1 ]; then
	if [ $bApNetwork == 1 ]; then
		UciJsonOutputWifiApInfo
	else
		UciJsonOutputAllNetworks
	fi

	# remove error message
	id=0

elif [ $bCmdInfo == 1 ]; then
	UciJsonOutputWifiNetworkInfo $id "$ssid"

	# remove error message (will be printed in json)
	#id=0 #TODO: confirm this is not needed

elif [ $bCmdClear == 1 ]; then
	ClearAllWifiNetworks

	# remove error message
	id=0

elif [ $bCmdReset == 1 ]; then
	ResetNetworkSettings

	# remove error message
	id=0

fi # command if else statement


# check that network was found
if [ $id == -1 ]; then
	_Print "> ERROR: specified ssid not in the database" "error"
	_SetError
fi

if [ $bError == 0 ]; then
	if 	[ $bCmdAdd == 1 ] ||
		[ $bCmdDisable == 1 ] ||
		[ $bCmdEnable == 1 ] ||
		[ $bCmdRemove == 1 ] ||
		# bCmdClear and bCmdReset are not considered because all wifi options will be reset
		[ $bCmdPriority == 1 ];
	then
		_Print "> Restarting wifimanager for changes to take effect" "status"
		wifi
	fi
fi



## json finish
_Close
