#ifndef _POWERDOCK_EXP_H_
#define _POWERDOCK_EXP_H_

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

#include <gpio.h>

//https://openwrt.org/docs/techref/hardware/port.gpio   -- calculating gpio offsets
//gpio base = cat /sys/class/gpio/gpiochip*/base | head -n1
// 512

#define POWERDOCK_CTRL_GPIO 			531 //19
#define POWERDOCK2_CTRL_GPIO 			528 //16

#define POWERDOCK_BATTERY_LEVEL0_GPIO           528 //16
#define POWERDOCK_BATTERY_LEVEL1_GPIO           530 //18

#define POWERDOCK_MAX_BATTERY_LEVEL		4



#ifdef __cplusplus
extern "C" {
#endif

//// Functions
int 		enableBatteryLevelIndicator			(int dockVersion);
int 		readBatteryLevel				(int *level0, int *level1);
int 		convertBatteryInputsToLevel			(int level0, int level1);



#ifdef __cplusplus
}
#endif
#endif // _POWERDOCK_EXP_H_
