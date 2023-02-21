# Omega2 Package Changelog


## Dec 19, 2022

* omega2-base
  * removed oupgrade-specific UCI setup - not yet using oupgrade in this firmware

## Nov 16, 2022

* omega2-base 
  * package versioning syntax changed. Package version now refers to OpenWRT release, Package release is build number
  * updated dependencies to include I2C, SD + eMMC, and filesystem kernel modules
  * Updated UCI defaults included in this package to:
    * set version numbers based on PKG VERSION AND BUILD NUMBER
    * set network to: 
      * Ethernet port to client mode
      * WiFi AP on, SSID is based on device name, DHCP is on
      * WiFi STA off
    * Add Onion package feed for this OpenWRT release to opkg feeds
    * Removed outdated/unneeded configs
* omega2-base-passwd
  * New package to set root user password - should be easy for end users to repalce this pacage
* omega2-usb-autorun
  * moved USB Autorun functionality into its own pacakge
* onion-repo-keys
  * updated version number to track OpenWRT release
