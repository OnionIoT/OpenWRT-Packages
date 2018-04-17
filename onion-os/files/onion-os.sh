#!/bin/sh

# include the Onion sh lib
. /usr/lib/onion/lib.sh

# function to return an array of all apps and if the app has an icon there
# 	argument 1: directory to check
AppList () {
	bExists=0

	# json setup
	json_init

	# create the directory array
	json_add_array apps

	#check if the directory exists
	if [ -d $1 ]
	then
		# denote that the directory exists
		bExists=1

		# grab all the app.json files and format to one line
		appList=`find $1 -name "app.json" | tr '\n' ';'`

		# split the list of json files
		rest=$appList
		while [ "$rest" != "" ]
		do
			val=${rest%%;*}
			rest=${rest#*;}

			# read in the contents of the json file
			appData=`cat $val | tr '\n' ' '`

			# find json commands to run for the app json file
			jshnCmd=`jshn -r "$appData"`
			# remove the json_init call
			jshnCmd=`echo $jshnCmd | sed -e 's/json_init;//'`

			# create and populate object for this app
			json_add_object
			eval $jshnCmd
			json_close_object
		done
	fi

	# finish the array
	json_close_array

	# add the note that the directory exists
	json_add_boolean exists $bExists

	# print the json
	json_dump
}

# function to control shellinabox daemon
ShellinaboxCtrl () {
	# find the commdn
	local cmd=""
	json_get_var cmd "command"

	# initialize json response object
	json_init

	# check arguments for supported commands
	if [ "$cmd" == "-start" ]
	then
		# start the shellinabox daemon (if there are none running)
		Log "ShellinaboxCtrl:: Start the shellinabox daemon, current count is $count"

		/etc/init.d/shellinabox start
		json_add_boolean "start" 1
	elif [ "$cmd" == "-check" ]
	then
		# check if the shellinabox daemon is running
		Log "ShellinaboxCtrl:: Check for shellinabox daemon"
		Log "ShellinaboxCtrl:: found following pids: $pids"

		# find the pids of any running shellinabox processes
		pids=$(_getPids shellinabox ubus)

		# count the number of processes
		count=0
		for pid in $pids
		do
			count=`expr $count + 1`
		done

		json_add_string "pids" "$pids"
		json_add_int "running" $count
	elif [ "$cmd" == "-stop" ]
	then
		# stop the shellinabox daemon
		Log "ShellinaboxCtrl:: Stop the shellinabox daemon"

		# stop shellinaboxd
		/etc/init.d/shellinabox stop

		json_add_int "stopped" 1
	elif [ "$cmd" == "-restart" ]
	then
		# stop the shellinabox daemon
		Log "ShellinaboxCtrl:: Stop the shellinabox daemon"

		# stop shellinaboxd
		/etc/init.d/shellinabox restart

		json_add_int "restart" 1
	else
		# unsupported command, do nothing
		Log "ShellinaboxCtrl:: unsupported command: $argument"
	fi

	# output the json
	json_dump
}


########################
##### Main Program #####

appLocation="/www/apps"

cmdAppList="app-list"
cmdShellinabox="shellinabox"
cmdStatus="status"

jsonAppList='"'"$cmdAppList"'": { }'
jsonShellinabox='"'"$cmdShellinabox"'": { "cmd": "value" }'
jsonStatus='"'"$cmdStatus"'": { }'


case "$1" in
    list)
		echo "{ $jsonAppList, $jsonShellinabox, $jsonStatus }"
    ;;
    call)
		Log "Function: call, Method: $2"

		case "$2" in
			$cmdAppList)
				# run the app-list scan
				AppList "$appLocation"
			;;
			$cmdShellinabox)
				# read the json arguments
				read input;
				Log "Json argument: $input"

				# parse the json
				json_load "$input"

				# parse the json and run the function
				ShellinaboxCtrl
			;;
			$cmdStatus)
				# dummy call for now
				echo '{"status":"good"}'
		;;
		esac
    ;;
esac

# take care of the log file
CloseLog
