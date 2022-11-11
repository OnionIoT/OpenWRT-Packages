#!/bin/sh

ramips_board_name() {
	local board
	board=$(cat /tmp/sysinfo/board_name)

	echo "${board#*,}"
}
