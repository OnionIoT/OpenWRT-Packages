# Omega2 Pro Package

The Omega2 Pro has 32MB of flash storage and 8 GB of eMMC Storage. 

By default, the OpenWRT operating system will boot from the 32MB flash storage. The Omega2 Pro package has a script, `o2-pro-init`, that will *essentially* move operating system to the eMMC chip.

This process is referred to as pivot overlay. It involves moving the writeable portion of the Omega’s firmware, the `overlay` partition, to the eMMC chip, with the read-only portion, the `rom` partition, remaining on the flash storage. 

## The `o2-pro-init` Script

The script will be installed at `/usr/bin/o2-pro-init` if the `omega2-pro-base` package is included/installed in the firmware. 
**It will run automatically at boot.**

In broad strokes, the script will do the following:

1. Check if OS has booted from overlay partition on the eMMC chip. If so, the script will exit - pivot overlay has already been set up. If not the script will continue
2. Format the eMMC chip and create the required partitions
3. Duplicate the existing `overlay` partition from the flash to the eMMC storage
4. Set configuration so `overlay` partition on the eMMC is automatically mounted
5. *Unrelated to pivot overlay:* Set up a swap file on the eMMC to increase available memory
6. Reboot the device

After the script has run once, the Omega2 Pro will hold the write-able portion of the operating system on the eMMC - meaning that you will be able to use the full 8GB for storage!

## More Information on Pivot Overlay

For more information, see our [documentation article on Booting from External Storage](https://docs.onion.io/omega2-docs/boot-from-external-storage.html).

## First Boot

It’s expected behavior for firmware upgrades to take about 5 minutes and for the device to reboot twice during the process.

The first reboot happens after the new firmware is installed. The second reboot is triggered by `o2-pro-init`, the initialization script that sets up the device so that the Operating System runs on the eMMC storage.
