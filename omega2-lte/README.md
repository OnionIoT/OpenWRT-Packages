# Omega2 LTE Base Package

This package includes the programs that are required to initialize and configure the cellular modem on the Omega2 LTE from the Linux environment.

This includes:

* `o2lte` script - user friendly interface to configure and control the cellular modem
* `lted` program and service - the driver program required to run the cellular modem as a Linux network interface

## `o2lte` Script

Source code can be found at [`files/omega2-lte.sh`](./files/omega2-lte.sh). It will be installed to `/usr/bin/o2lte` on the device.

To learn how to use the script, see the [Omega2 LTE Guide on the Onion site](https://onion.io/omega2-lte-guide/). 
You can also run `o2lte --help` on the Omega2 LTE, or take a look at the [`usage` function in the script source code.](./files/omega2-lte.sh)

## `lted` Program and Service

The `lted` program is based on a driver program made available by Quectel, the producers of the modem used on the Omega2 LTE. See Onion's fork of the driver program here: https://github.com/OnionIoT/quectel-cm

After initial configuration of the cellular network APN, the `lted` program will be run automatically as a service by the Linux operating system of the Omega2 LTE. 
See [`files/init.d/lted.sh`](./files/init.d/lted.sh) for the `init.d` service definition. 

