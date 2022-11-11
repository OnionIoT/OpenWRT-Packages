#!/bin/sh
#### Description: USB autorun script for the Onion Omega2
#### Pleace autorun.sh and auth.txt under the USB root directory
#### Written by: Onion Corporation https://onion.io


echo "${DEVNAME} ${ACTION}" > /tmp/ar.log  #DBG

# USB drive with multiple partitions will triger hotplug multiple  times.
# we are only interested in one of them
[ "${DEVNAME}" = "" ] && {
    exit 0
}

[ "${ACTION}" == "bind" ] && {
    usbAutorun start &
}


[ "${ACTION}" = "remove" ] && {
    usbAutorun stop &
}
