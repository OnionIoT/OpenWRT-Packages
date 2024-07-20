#ifndef _GPIO_H_
#define _GPIO_H_

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>


#ifdef __cplusplus
extern "C" {
#endif

//// Functions
int 		GpioSet 						(int gpioPin, int value);
int 		GpioGet 						(int gpioPin, int *value);


#ifdef __cplusplus
}
#endif
#endif // _GPIO_H_