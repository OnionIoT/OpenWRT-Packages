#ifndef _ONIONDEBUG_H_
#define _ONIONDEBUG_H_

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>


#ifdef __cplusplus
extern "C" {
#endif

#define ONION_VERBOSITY_NONE    0
#define ONION_VERBOSITY_ERROR   1    
#define ONION_VERBOSITY_WARN    2    
#define ONION_SEVERITY_INFO     3
#define ONION_SEVERITY_DEBUG    4

void onionPrint(int verbosity, char *s, ...);
void onionSetVerbosity(int verbosity);

#ifdef __cplusplus
}
#endif
#endif // _ONIONDEBUG_H_
