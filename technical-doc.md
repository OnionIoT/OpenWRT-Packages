# Usage Instructions for New OpenWRT-22.03-based Omega2 Firmware

A new firmware is available for the Omega2 and Omega2+ that's based on the recent OpenWRT 22.03 release.

This page has instructions on using this new firmware:

- [Installing the New Firmware](#installing-the-new-firmware)
  * [Selecting Firmware](#selecting-firmware)
  * [Installing the firmware](#installing-the-firmware)
  * [Updating](#updating)
- [Connecting to the Device](#connecting-to-the-device)
- [Using the Hardware Interfaces](#using-the-hardware-interfaces)
  * [Ethernet Networking](#ethernet-networking)
    + [Ethernet Port as DHCP Client](#ethernet-port-as-dhcp-client)
    + [Ethernet Port as DHCP Host](#ethernet-port-as-dhcp-host)
  * [Wireless Networking](#wireless-networking)
    + [AP](#ap)
    + [STA](#sta)
    + [Combinations of AP and STA](#combinations-of-ap-and-sta)
  * [External Storage](#external-storage)
    + [USB](#usb)
    + [SD Card](#sd-card)
  * [I2C](#i2c)
  * [SPI](#spi)
  * [GPIO](#gpio)
- [Feedback]

# Installing the New Firmware

> This firmware doesn't include the `oupgrade` utility, so we'll need to manually install the firmware. The procedure is very similar to the [Manual Firmware Installation instructions in the Onion Documentation](http://docs.onion.io/omega2-docs/manual-firmware-installation.html). 

The new firmware can be found online at http://repo.onioniot.com/omega2/images/openwrt-22.03/

The firmware images are named according to this syntax: `<DEVICE-NAME>-<OPENWRT-VERSION>-<BUILD-DATE>.bin`
So `onion_omega2p-22.03.2-20230221.bin` is firmware made for the Omega2+/Omega2S+, based on OpenWRT release 22.03.2, and was built on Feb 21, 2023.


## Selecting Firmware

Before you install firmware to your device, you'll need to decide which firmware image to install.

First, you'll need to find the firmware for your device:

* Firmware for Omega2/Omega2S starts with `onion_omega2-`
* Firmware for Omega2**+**/Omega2S**+** starts with `onion_omega2p-`.

Then, you'll want to select the **highest** OpenWRT release and the **latest** build date. This will ensure you're using the very latest available firmware.

Make a note of the filename of the firmware you've selected.


## Installing the firmware

**WARNING: this will erase everything that's currently on your device. Back up anything that you don't want to lose forever!**

Once you know which firmware image you want to install on your device:

1. Connect to the command line of your device
1. Go to the `/tmp` directory: `cd /tmp`
1. Download the firmware image: `wget http://repo.onioniot.com/omega2/images/openwrt-22.03/<SELECTED-FIRMWARE-IMAGE>.bin`
1. Install the firwmare: `sysupgrade -F -n -v <SELECTED-FIRMWARE-IMAGE>.bin`

Say you selected firmware `onion_omega2p-22.03.2-20230221.bin`:

* Your download command would be `wget http://repo.onioniot.com/omega2/images/openwrt-22.03/onion_omega2p-22.03.2-20230221.bin`
* Your installation command would be `sysupgrade -F -n -v onion_omega2p-22.03.2-20230221.bin`


## Updating

From time to time, we'll be releasing new firmware images with various updates. You can follow the instructions above to install the latest firmware on your device - just keep an eye on the build date to make sure you're on the latest version.

**WARNING**: because `sysupgrade` is run with the `-n` option, **everything that's currently on the device will be erased when the firwmare is updated.** So all new files and changes on your device will be deleted as part of the upgrade process, and you will start with a fresh device.

# Connecting to the Device

Once the new firmware is installed on a device, users can connect to the device either A) using the local network to connect through **SSH** or B) using a USB connection to connect to the **serial terminal**.

This works just like it did in the earlier firmware released by Onion for the Omega2. The user is still `root` and the default password is `onioneer`.

See the [Connecting to the Command Line](http://docs.onion.io/omega2-docs/connecting-to-the-omega-terminal.html) article in the Onion Documentation for details.

> **Note**: Devices with this firmware will not have the `omega-abcd.local` hostname on the local network. You will need to use the local IP address for SSH connections.


# Using the Hardware Interfaces

A run-down of how to use the hardware interfaces in the new firmware.

## Ethernet Networking

### Ethernet Port as DHCP Client

Default network configuration is for ethernet port to act as DHCP client. It expects to receive an IP address from a DHCP server on the network (a router or similar).

### Ethernet Port as DHCP Host

To configure the ethernet port to act as the DHCP Host/Server:

```bash
uci del network.wan.device
uci add_list network.@device[0].ports='eth0'
uci commit network
/etc/init.d/network restart
```

In this case, any device connected to the ethernet port will receive an IP address from the Omega2. 

The Omega2 ethernet port will have 192.168.4.1 set as its IP address, and it will give IP addresses to clients in the range of 192.168.4.100 to 192.168.4.150.

To check the IP addresses given to a connected client, run `cat /tmp/dhcp.leases`

## Wireless Networking

The open source mt76 driver is used for wireless networking.

### AP

By default, Omega2 will host an AP (Access Point) network. It will be named `Omega-abcd` where `abcd` matches the last four digits of the device’s MAC address

To disable the AP:

```bash
uci set wireless.default_radio0.disabled='1'
uci commit wireless
wifi
```

The Omega2 WiFi AP will have 192.168.3.1 set as its IP address and it will give IP address to clients in the 192.168.3.100 to 192.168.3.150 range.

To check the IP addresses given to connected clients, run `cat /tmp/dhcp.leases`


### STA

To connect the Omega2 to an existing wireless network (with WPA2 security), run the following commands:

```bash
uci set wireless.client.ssid='<YOUR WIFI NETWORK NAME HERE>'
uci set wireless.client.key='<YOUR WIFI NETWORK PASSWORD HERE>'
uci set wireless.client.disabled='0'
uci commit wireless
wifi
```

To disable this functionality of the radio and disconnect from any connected radio:

```bash
uci set wireless.client.disabled='1'
uci commit wireless
wifi
```

Note: the Omega2 will only connect to the wireless network specified. This version of OpenWRT does not support automatic network switching.

### Combinations of AP and STA

With this version of OpenWRT, the Omega2 supports:

- AP: Just the network hosted by the Omega2
- STA: Just connecting to an existing wireless network
- AP+STA: Hosting a network and connecting to an existing wireless network

The AP can be controlled through `uci` and the `wireless.default_radio0.disabled` parameter.

And the STA can be controlled through `uci` and the `wireless.client.disabled` parameter.

## External Storage

This firmware includes the kernel modules required for external USB and SD Card storage - including support for a variety of filesystems. 

### USB

Plug in a USB drive and you’ll see a message like:

```
[ 1704.267974] usb 1-1: new high-speed USB device number 2 using ehci-platform
[ 1704.479893] usb-storage 1-1:1.0: USB Mass Storage device detected
[ 1704.502029] scsi host0: usb-storage 1-1:1.0
[ 1705.530163] scsi 0:0:0:0: Direct-Access     Generic  Flash Disk       8.07 PQ: 0 ANSI: 4
[ 1705.549739] sd 0:0:0:0: [sda] 15728640 512-byte logical blocks: (8.05 GB/7.50 GiB)
[ 1705.559385] sd 0:0:0:0: [sda] Write Protect is off
[ 1705.564277] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
[ 1705.565444] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1705.583833]  sda: sda1
[ 1705.596761] sd 0:0:0:0: [sda] Attached SCSI removable disk
```

Note from the second last line, the new device is called `sda1`

The filesystem from the USB drive will be automatically mounted to the `/mnt/` directory, with the name of the device as the full path, so `/mnt/sda1` in this case:

```bash
root@Omega-F19D:/# ls -l /mnt/sda1
drwxrwxrwx    2 root     root          4096 Jun  1  2018 System Volume Information
-rwxrwxrwx    1 root     root             0 Jun 17  2021 omega2p-v0.3.3-b251.bin
```

**Unmount the filesystem before removing the USB drive:**

```bash
umount /mnt/sda1
```

### SD Card

Insert an SD Card and you will see a message like the following:

```bash
[ 2757.012387] mmc0: new high speed SDHC card at address 0007
[ 2757.026510] mmcblk0: mmc0:0007 SD8GB 7.21 GiB
[ 2757.033860]  mmcblk0: p1
```

The filesystem from the SD CARD will be automatically mounted to the `/mnt/` directory, with the name of the device + filesystem as the full path, so `/mnt/mmcblk0p1` in this case:

```bash
root@Omega-F19D:/# ls -l /mnt/mmcblk0p1/
-rw-r--r--    1 root     root            29 Nov 21 17:09 log.txt
```

**Unmount the filesystem before removing the SD card:**

```bash
umount /mnt/mmcblk0p1
```

## I2C

The firmware includes the kernel modules needed to use the hardware I2C bus as well as the `i2c-tools` command line tools.

The I2C bus interface is available at `/dev/i2c-0`

See the [i2c-tools documentation](https://linuxhint.com/i2c-linux-utilities/) to learn how to use the individual commands.

## SPI

Included are the spidev kernel modules that allow use of CS1 with this hardware SPI bus.

The interface is available at `/dev/spidev0.1`

## GPIO

The GPIOs can be accessed through the GPIO sysfs interface, see the [documentation](https://www.kernel.org/doc/Documentation/gpio/sysfs.txt) for details. 

> The GPIO sysfs interface is deprecated but is currently the best option for userspace GPIO access. More context available in [this post by Luz on the Onion Community](https://community.onion.io/topic/4892/can-bus-using-mcp2515-with-omega2/13).

An important note: because of changes in the kernel, the GPIOs are not numbered like they were before:

- GPIO 0 - 31 ⇒ GPIO 480 - 511  (GPIO n + 480)
- GPIO 32 - 63 ⇒ GPIO 448 - 479 (GPIO n + 416)

### `gpio-lookup` utility

To simplify Omega2 GPIO mapping a new utility `gpio-lookup` has been introduced, which would generate equivalent kernel GPIO numbers against given an "actual" GPIO number.

Here are a few examples of how to use `gpio-lookup`.

```bash
# gpio-lookup 15
495

# gpio-lookup 62
478

# gpio-lookup 99
-1
```

For valid GPIO numbers, `gpio-lookup` would display the corresponding kernel GPIO number, for all other cases It would display `-1` with a non-zero exit code.

# Feedback

We would love to hear what you think about this new firmware and collaborate with you to improve it!

For general discussion, feel free to post on the [Onion Community](https://community.onion.io/category/2/omega-talk).

If you have specific improvement suggestions or bugs to report, please **create an Issue in the [OnionIoT/OpenWRT-Packages GitHub Repo](https://github.com/OnionIoT/OpenWRT-Packages)**.
There are issue templates for Bug Reports and Improvement Suggestions/Feature Requests.

If there's something unclear or missing in this documentation, or it can be improved in some way, create an issue in the [OnionIoT/OpenWRT-Packages GitHub Repo](https://github.com/OnionIoT/OpenWRT-Packages) and explain what could be better documented.

