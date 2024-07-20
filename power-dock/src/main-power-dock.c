#include <power-dock.h>
#include <onion-debug.h>

void usage(const char* progname)
{
	printf("Power-dock\n");
	printf("Usage: %s [-qv] [-l]\n", progname);
	printf("\n");
	printf("FUNCTIONALITY:\n");
	printf("\tEnables the Battery Level Indicator LEDs on the Onion Power Dock.\n");
	printf("\n\n");
	printf("OPTIONS:\n");
	printf(" -l 		show battery level measurement\n");
	printf(" -q 		quiet: no output\n");
	printf(" -v 		verbose: lots of output\n");
	printf(" -2 		Power Dock 2\n");
	printf(" -h 		help: show this prompt\n");
        
	printf("\n");
}

int main(int argc, char** argv)
{
	int 	ch;
	const char *progname;
	char 	*command;
	int 	status;

	int 	verbose = ONION_SEVERITY_INFO;
	int 	quiet;
	int 	level0, level1;
	int 	batteryLevel;

	int 	dockVersion	= 1;

	// save the program name
	progname 	= argv[0];

	while ((ch = getopt(argc, argv, "vqht2l")) != -1) {
		switch (ch) {
			case 'v':
				// verbose output
				verbose++;
				break;
			case 'q':
				// quiet output
				verbose = ONION_VERBOSITY_NONE;
				break;
			case 'l':
				// enable reading the battery level
				level0 	= 0;
				level1 	= 0;
				break;
			case '2':
				// Power Dock 2 mode
				dockVersion	= 2;
				break;
			default:
				// display usage printout
				usage(progname);
				return 0;
		}
	}

	onionSetVerbosity(verbose);
	argc 	-= optind;
	argv	+= optind;


	// enable the battery level indicator LEDs
	onionPrint(ONION_SEVERITY_INFO, "> Enabling Battery Indicator LEDs\n");
	status  = enableBatteryLevelIndicator(dockVersion);


	// read the battery level (only for Power Dock 1)
	if (level0 == 0 && level1 == 0 && dockVersion == 1) {
		onionPrint(ONION_SEVERITY_INFO, "> Reading Battery Level Pins\n");
		status 	|= readBatteryLevel(&level0, &level1);

		onionPrint(ONION_SEVERITY_DEBUG, "   Level0: %d (GPIO%d)\n", level0, POWERDOCK_BATTERY_LEVEL0_GPIO);
		onionPrint(ONION_SEVERITY_DEBUG, "   Level1: %d (GPIO%d)\n", level1, POWERDOCK_BATTERY_LEVEL1_GPIO);

		batteryLevel = convertBatteryInputsToLevel(level0, level1);

                printf("Battery Level: %d/%d\n", batteryLevel, POWERDOCK_MAX_BATTERY_LEVEL);
		onionPrint(ONION_SEVERITY_INFO, " Battery Level: %d/%d\n", batteryLevel, POWERDOCK_MAX_BATTERY_LEVEL);
	}

	return 0;
}
