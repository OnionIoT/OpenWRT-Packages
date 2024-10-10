# Usage Instructions for New OpenWRT-23.05-based Omega2 Firmware

A new firmware is available for the Omega2 and Omega2+ that's based on the recent OpenWRT 23.05 release.

This page used to hold instructions on using this new firmware. However, **this has been moved to the Documentation site for the new firmware at https://documentation.onioniot.com/**


# Installing the New Firmware

See https://documentation.onioniot.com/firmware/installing-firmware

## Selecting Firmware

See https://documentation.onioniot.com/firmware/installing-firmware#selecting-firmware


## Installing the firmware

See https://documentation.onioniot.com/firmware/installing-firmware#installing-the-firmware

## Updating

See https://documentation.onioniot.com/firmware/installing-firmware#updating

# Connecting to the Device

See https://documentation.onioniot.com/quickstart/serial-command-line/


> Once the new firmware is installed on a device, users can connect to the device either A) using the local network to connect through **SSH** or B) using a USB connection to connect to the **serial terminal**.
> 
> This works just like it did in the earlier firmware released by Onion for the Omega2. The user is still `root` and the default password is `onioneer`.
>
> See the [Connecting to the Command Line](http://docs.onion.io/omega2-docs/connecting-to-the-omega-terminal.html) article in the Onion Documentation for details.
>
> **Note**: Devices with this firmware will not have the `omega-abcd.local` hostname on the local network. You will need to use the local IP address for SSH connections.


# Using the Hardware Interfaces

A run-down of how to use the hardware interfaces in the new firmware.

## Ethernet Networking

See https://documentation.onioniot.com/networking/ethernet

### Ethernet Port as DHCP Client

See https://documentation.onioniot.com/networking/ethernet#ethernet-port-as-dhcp-client

### Ethernet Port as DHCP Host

See https://documentation.onioniot.com/networking/ethernet#ethernet-port-as-dhcp-host

## Wireless Networking

See https://documentation.onioniot.com/networking/wifi

### AP

See https://documentation.onioniot.com/networking/wifi#ap

### STA

See https://documentation.onioniot.com/networking/wifi#sta

### Combinations of AP and STA

See https://documentation.onioniot.com/networking/wifi#apsta

## External Storage

This firmware includes the kernel modules required for external USB and SD Card storage - including support for a variety of filesystems. 

### USB

See https://documentation.onioniot.com/hardware-interfaces/usb#usb-storage

### SD Card

See https://documentation.onioniot.com/hardware-interfaces/sdio#sd-card

## I2C

See https://documentation.onioniot.com/hardware-interfaces/i2c

## SPI

See https://documentation.onioniot.com/hardware-interfaces/spi

### Python `spidev` Module

See https://documentation.onioniot.com/hardware-interfaces/spi#interacting-with-the-spi-bus

## GPIO

See https://documentation.onioniot.com/hardware-interfaces/gpio

### `gpio-lookup` utility

Not needed for Onion firmware based on OpenWRT 23.05

## Pin Multiplexing

See https://documentation.onioniot.com/hardware-interfaces/pin-multiplexing

## Hardware PWM

See https://documentation.onioniot.com/hardware-interfaces/pwm

### Enabling Hardware PWM 

See https://documentation.onioniot.com/hardware-interfaces/pwm#enabling-hardware-pwm

### Enabling PWM Pins

See https://documentation.onioniot.com/hardware-interfaces/pwm#adjusting-pin-multiplexing-to-enable-pwm-pins

### Generating PWM Signals

See https://documentation.onioniot.com/hardware-interfaces/pwm#generating-pwm-signals

### Stopping the PWM signal

See See https://documentation.onioniot.com/hardware-interfaces/pwm#generating-pwm-signals


### Writing your own script to generate PWM signals

See the source code for the `onion pwm` if you're interested in writing your own script: https://github.com/OnionIoT/OpenWRT-Packages/blob/openwrt-23.05/omega2-base/files/usr/lib/onion-pwm-lib.sh


# Software 

Anything software-related for the new firmware.

## NodeJS v16.19

See https://documentation.onioniot.com/software/supported-languages#nodejs

# Feedback

We would love to hear what you think about this new firmware and collaborate with you to improve it!

For general discussion, feel free to post on the [Onion Community](https://community.onion.io/category/2/omega-talk).

If you have specific improvement suggestions or bugs to report, please **create an Issue in the [OnionIoT/OpenWRT-Packages GitHub Repo](https://github.com/OnionIoT/OpenWRT-Packages)**.
There are issue templates for Bug Reports and Improvement Suggestions/Feature Requests.

If there's something unclear or missing in this documentation, or it can be improved in some way, create an issue in the [OnionIoT/documentation GitHub Repo](https://github.com/OnionIoT/documentation) and explain what could be better documented.


