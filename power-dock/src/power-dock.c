#include <power-dock.h>
#include <onion-debug.h>


///////////////////////////////////////
// Battery IC Functions
///////////////////////////////////////

int enableBatteryLevelIndicator(int dockVersion) {
	int status;
	int ctrlGpio = POWERDOCK_CTRL_GPIO;
	if (dockVersion == 2) {
		ctrlGpio = POWERDOCK2_CTRL_GPIO;
	}

        printf("Dock version: %d\n", dockVersion);
	//Set CTRL GPIO to Low
	//Wait for 200 ms
	//Set CTRL GPIO to High
	//Wait 100 ms
	//Set CTRL GPIO back low

	onionPrint(ONION_SEVERITY_DEBUG, "   Pulsing ctrl pin: GPIO%d\n", ctrlGpio);


	status = GpioSet(ctrlGpio, 0);
	usleep(200 * 1000);
	status |= GpioSet(ctrlGpio, 1);
	usleep(100 * 1000);
	status |= GpioSet(ctrlGpio, 0);

	return status;
}

int readBatteryLevel(int *level0, int *level1) {
	int status;

	status 	= GpioGet(POWERDOCK_BATTERY_LEVEL0_GPIO, level0);
	status 	|= GpioGet(POWERDOCK_BATTERY_LEVEL1_GPIO, level1);

	return status;
}

int convertBatteryInputsToLevel(int level0, int level1) {
	// truth table:
	//	GPIO 18		GPIO16		Battery level
	//	(level1)	(level0)
	//----------------------------------------
	//	HIGH		LOW 		4/4 - 100%
	//	HIGH		HIGH		3/4 - 75%
	//	LOW  		HIGH		2/4 - 50%
	//	LOW 		LOW			1/4 - 25%
	int batteryLevel = 0;

	if (level1 == 1 && level0 == 0) {
		batteryLevel = 4;
	}
	else if (level1 == 1 && level0 == 1) {
		batteryLevel = 3;
	}
	else if (level1 == 0 && level0 == 1) {
		batteryLevel = 2;
	}
	else if (level1 == 0 && level0 == 0) {
		batteryLevel = 1;
	}

	return batteryLevel;
}
///////////////////////////////////////
