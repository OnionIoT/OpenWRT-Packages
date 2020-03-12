# Omega2 Dash Base Package

This package handles adding everything that is required to use a ILI9341 320x240 pixel TFT display to the Omega2 firmware.

This includes:

* Required kernel drivers
* Mechanism to load and configure the kernel drivers

## The Kernel Drivers

Proper operation of the ILI9341 TFT display on the Omega2 Dash depends on kernel modules that:

1. Enable the Linux framebuffer - `kmod-fb`
2. Enable support for writing out the framebuffer to TFT devices - `kmod-fbtft-support`
3. The specific framebuffer to TFT driver for the ILI9341 device - `kmod-fbtft-ili9341`

**Note:** These kernel modules are NOT compiled by default in the `openwrt-18.06` release of the OpenWRT build system. [This commit](https://github.com/OnionIoT/source/commit/52a1594fbbabbfeeaad12496eabcaee1a794fbd6) in Onion's fork of the OpenWRT source repo enables compilation of these kernel modules, and adds the Omega2 Dash as a device.

## Mechanism to Load and Configure the Kernel Driver

Also installed by this package is a `/etc/modules.d` listing that ensures the ILI9341 FBTFT kernel driver is loaded at boot-time with the proper configuration for the Omega2 Dash hardware.

References:
* See the [OpenWRT procd documentation](https://openwrt.org/docs/techref/procd) for more details on `/etc/modules.d`
* See the [fbtft wiki](https://github.com/notro/fbtft/wiki/fbtft_device#parameters) for more details on the configuration parameters.

# Compiling Firmware with ILI9341 TFT Display Support

To compile your own copy of the official Omega2 Dash firmware:

1. Clone the [Onion fork of the OpenWRT source repo](https://github.com/OnionIoT/source)
2. Follow the instructions in the README to set it up
3. Before launching compilation, run `python scripts/onion-setup-build.py -c .config.O2Dash`. This will change the build system configuration to Onion's configuration for the Omega2 Dash.
4. Compile the firmware

## Alternatives

Also possible to make your own firmware by:

* Selecting `Omega2 Dash` as the target device through the build system's menuconfig 

**OR**

* Selecting the `omega2-dash-base` package to be **built-in** to your firmware (using the build system's menuconfig)
