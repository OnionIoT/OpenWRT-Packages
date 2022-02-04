#!/bin/sh

readMacAddr () {
  line1=$(hexdump -s 4 -n 6 /dev/mtd2 | sed -n '1p' | sed -e 's/^........//')
  mac=$(echo $line1 | awk -F " " '{print substr($1,3) substr($1,1,2) substr($2,3) substr($2,1,2) substr($3,3) substr($3,1,2)}')
  echo "$mac"
}

readUci () {
  local value
  value=$(uci -q get $1 2> /dev/null)
  echo "$value" 
}

readVersionNumber () {
  PACKAGE=onion
  FIRMWARE_CONFIG=${PACKAGE}.@${PACKAGE}[0]

  version=$(readUci ${FIRMWARE_CONFIG}.version)
  if [ "$version" != "" ]; then
    build=$(readUci ${FIRMWARE_CONFIG}.build)
    if [ "$build" != "" ]; then
      echo "v${version}-b${build}"
      return
    fi
  fi

  echo ""
}

readDeviceName () {
  device=$(cat /proc/cpuinfo | grep machine | sed -e 's/.*\: //')
  echo "$device"
}

main () {
  mac=$(readMacAddr)
  versionNumber=$(readVersionNumber)
  device=$(readDeviceName)

  echo -e "${mac}\t${versionNumber}\t${device}"
}

main
