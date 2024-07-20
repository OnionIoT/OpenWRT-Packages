#include <gpio.h>
#include <ugpio/ugpio.h>


///////////////////////////////////////
// Helper Functions
int _GpioInit(int gpioPin) 
{
	int 	bRequest;

	// check that gpio is free
	if ((bRequest = gpio_is_requested(gpioPin)) < 0)
	{
		return EXIT_FAILURE;
	}

	// request the pin
	if (!bRequest) {
		if ((gpio_request(gpioPin, NULL)) < 0)
		{
			return EXIT_FAILURE;
		}
	}	

	return 	EXIT_SUCCESS;
}

int _GpioClose(int gpioPin)
{
	if (gpio_free(gpioPin) < 0)
	{
		return EXIT_FAILURE;
	}

	return 	EXIT_SUCCESS;
}


// public functions
int GpioSet (int gpioPin, int value)
{
	int 	status;

	// initialize the pin
	status 	= _GpioInit(gpioPin);

	if (status == EXIT_SUCCESS) {
		// set the value
		value 	= (value == 1 ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW);
		status 	= gpio_direction_output(gpioPin, value);

		if (status < 0) {
			status = EXIT_FAILURE;
		}

		// close the pin
		status 	|= _GpioClose(gpioPin);
	}

	return 	status;
}

int GpioGet (int gpioPin, int *value)
{
	int 	status;

	// initialize the pin
	status 	= _GpioInit(gpioPin);

	if (status == EXIT_SUCCESS) {
		status 	= gpio_direction_input(gpioPin);

		if (status >= 0) {
			*value = gpio_get_value(gpioPin);
		}
		else {
			status = EXIT_FAILURE;
		}

		// close the pin
		status 	|= _GpioClose(gpioPin);
	}

	return 	status;
}
///////////////////////////////////////