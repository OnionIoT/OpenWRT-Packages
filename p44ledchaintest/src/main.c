//
//  main.c
//  p44ledchaintest
//
//  Copyright © 2020 plan44.ch. All rights reserved.
//

#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <getopt.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

#define DEFAULT_NUMLEDS 720
#define DEFAULT_UPDATEINTERVAL_MS 30
#define DEFAULT_FGCOLOR "FF0000"
#define DEFAULT_BGCOLOR "000040"
#define DEFAULT_COLORSTEP "000000"
#define DEFAULT_NUMREPEATS 1
#define DEFAULT_EFFECTINC 1

static void usage(const char *name)
{
  fprintf(stderr, "usage:\n");
  fprintf(stderr, "  %s [options] ledchaindevice [ledchaindevice, ...]\n", name);
  fprintf(stderr, "    -n numleds : number of LEDs per chain (default: %d)\n", DEFAULT_NUMLEDS);
  fprintf(stderr, "    -i interval[ms] : update interval (default: %d)\n", DEFAULT_UPDATEINTERVAL_MS);
  fprintf(stderr, "    -r repeats : how many repeated updates, 0=continuously, (default: %d)\n", DEFAULT_NUMREPEATS);
  fprintf(stderr, "    -e inc : effect increment, (default: %d)\n", DEFAULT_EFFECTINC);
  fprintf(stderr, "    -c rrggbb : hex color (default: %s)\n", DEFAULT_FGCOLOR);
  fprintf(stderr, "    -b rrggbb : alternate (background) hex color (default: %s)\n", DEFAULT_BGCOLOR);
  fprintf(stderr, "    -s rrggbb : color increment added at each step (default: %s)\n", DEFAULT_COLORSTEP);
  fprintf(stderr, "    -H ooccttttrr : send header data (needed for ledchain in variable led type mode)\n");
  fprintf(stderr, "       (for p44-ledchain >=v6: oo=layout, cc=chip, tttt=tmaxpassive, rr=maxretries)\n");
  fprintf(stderr, "    -F : fill up / empty led chain with foreground color\n");
  fprintf(stderr, "    -S : single wandering LED with foreground color\n");
  fprintf(stderr, "    -v : verbose\n");
}


static long long now()
{
  #if defined(__APPLE__) && __DARWIN_C_LEVEL < 199309L
  // pre-10.12 MacOS does not yet have clock_gettime
  static bool timeInfoKnown = false;
  static mach_timebase_info_data_t tb;
  if (!timeInfoKnown) {
    mach_timebase_info(&tb);
  }
  double t = mach_absolute_time();
  return t * (double)tb.numer / (double)tb.denom / 1e3; // uS
  #else
  // platform has clock_gettime
  struct timespec tsp;
  clock_gettime(CLOCK_MONOTONIC, &tsp);
  // return microseconds
  return ((uint64_t)(tsp.tv_sec))*1000000ll + tsp.tv_nsec/1000; // uS
  #endif
}


// globals
// - options and params from cmdline
int numleds = DEFAULT_NUMLEDS;
int interval = DEFAULT_UPDATEINTERVAL_MS;
uint8_t fgcolor[3] = { 0xFF, 0, 0};
uint8_t bgcolor[3] = { 0, 0, 0x40};
uint8_t colorstep[3] = { 0, 0, 0};
int effectinc = DEFAULT_EFFECTINC;
int repeats = DEFAULT_NUMREPEATS;
int verbose = 0;

enum {
  mode_static, // static foreground fill
  mode_fillup, // fill and empty chain with foreground
  mode_single, // single wandering LED with foreground color
};
int mode = mode_static;

const int maxchains = 4;
const int maxhdrlen = 20;

int main(int argc, char **argv)
{
  int chainFds[maxchains];
  int numchains;
  int loopidx, cidx, lidx, eidx;
  struct timespec ts;
  uint8_t *rawbuffer;
  uint8_t *ledbuffer;
  const char* headerStr = NULL;
  int hdrlen = 0;

  long long start;
  long long loopStart;
  long long beforeUpdate;
  long long afterUpdate;
  long long afterSleep;
  long long afterPrint;
  long long lastAfterSleep;
  long long total;
  long long wait;

  if (argc<2) {
    // show usage
    usage(argv[0]);
    exit(1);
  }

  int c;
  while ((c = getopt(argc, argv, "hH:n:i:e:r:c:b:s:vFS")) != -1)
  {
    switch (c) {
      case 'h':
        usage(argv[0]);
        exit(0);
      case 'n':
        numleds = atoi(optarg);
        break;
      case 'i':
        interval = atoi(optarg);
        break;
      case 'e':
        effectinc = atoi(optarg);
        break;
      case 'r':
        repeats = atoi(optarg);
        break;
      case 'c':
        sscanf(optarg, "%2hhx%2hhx%2hhx", &fgcolor[0], &fgcolor[1], &fgcolor[2]);
        break;
      case 'b':
        sscanf(optarg, "%2hhx%2hhx%2hhx", &bgcolor[0], &bgcolor[1], &bgcolor[2]);
        break;
      case 's':
        sscanf(optarg, "%2hhx%2hhx%2hhx", &colorstep[0], &colorstep[1], &colorstep[2]);
        break;
      case 'H':
        headerStr = optarg;
        break;
      case 'v':
        verbose = 1;
        break;
      case 'F':
        mode = mode_fillup;
        break;
      case 'S':
        mode = mode_single;
        break;
      default:
        exit(-1);
    }
  }
  // open chains
  numchains = 0;
  while (optind<argc) {
    chainFds[numchains] = open(argv[optind], O_RDWR);
    if (chainFds[numchains]<0) {
      fprintf(stderr, "cannot open ledchain device '%s': %s\n", argv[optind], strerror(errno));
      exit(1);
    }
    numchains++;
    optind++;
  }
  if (numchains<1) {
    fprintf(stderr, "must specify at least one LED chain device\n");
    exit(1);
  }
  // allocate buffer
  rawbuffer = malloc(numleds*3+maxhdrlen+1);
  ledbuffer = rawbuffer;
  // maybe we have a header
  if (headerStr) {
    ledbuffer++; // room for length
    hdrlen = 1;
    while (hdrlen<maxhdrlen && sscanf(headerStr, "%2hhx", ledbuffer)==1) {
      headerStr +=2;
      hdrlen++;
      ledbuffer++;
    }
    *rawbuffer = hdrlen-1;
  }
  // loop
  start = now();
  eidx = 0; // effect index
  for (loopidx = 0; repeats==0||loopidx<repeats; loopidx++) {
    loopStart = now();
    // prepare pattern
    switch(mode) {
      case mode_static: {
        for (lidx=0; lidx<numleds; lidx++) {
          ledbuffer[lidx*3+0] = fgcolor[0];
          ledbuffer[lidx*3+1] = fgcolor[1];
          ledbuffer[lidx*3+2] = fgcolor[2];
        }
        break;
      }
      case mode_fillup:
      {
        for (lidx=0; lidx<(eidx%numleds); lidx++) {
          ledbuffer[lidx*3+0] = fgcolor[0];
          ledbuffer[lidx*3+1] = fgcolor[1];
          ledbuffer[lidx*3+2] = fgcolor[2];
        }
        for (; lidx<numleds; lidx++) {
          ledbuffer[lidx*3+0] = bgcolor[0];
          ledbuffer[lidx*3+1] = bgcolor[1];
          ledbuffer[lidx*3+2] = bgcolor[2];
        }
        break;
      }
      case mode_single:
      {
        for (lidx=0; lidx<numleds; lidx++) {
          if ((eidx%numleds)==lidx) {
            ledbuffer[lidx*3+0] = fgcolor[0];
            ledbuffer[lidx*3+1] = fgcolor[1];
            ledbuffer[lidx*3+2] = fgcolor[2];
          }
          else {
            ledbuffer[lidx*3+0] = bgcolor[0];
            ledbuffer[lidx*3+1] = bgcolor[1];
            ledbuffer[lidx*3+2] = bgcolor[2];
          }
        }
        break;
      }
    }
    // update chains
    beforeUpdate = now();
    for (cidx = 0; cidx<numchains; cidx++) {
      write(chainFds[cidx], rawbuffer, numleds*3+hdrlen);
    }
    afterUpdate = now();
    // calculate remaining wait time
    wait = interval*1000 - (afterUpdate-loopStart);
    // wait
    ts.tv_sec = wait/1000000;
    ts.tv_nsec = (wait%1000000)*1000;
    nanosleep(&ts, NULL);
    lastAfterSleep = afterSleep;
    afterSleep = now();
    total = now()-start;
    // statistics
    if (verbose) {
      printf("Loop #%d: TOTAL:%lld, average loop: %lld - THIS loop:%lld, generate: %lld, update: %lld, wait: %lld, prev. printf: %lld [µS]\n",
        loopidx,
        total,
        total/(loopidx+1),
        afterSleep-loopStart,
        beforeUpdate-loopStart,
        afterUpdate-beforeUpdate,
        afterSleep-afterUpdate,
        afterPrint-lastAfterSleep
      );
    }
    afterPrint = now();
    eidx += effectinc;
    fgcolor[0] += colorstep[0];
    fgcolor[1] += colorstep[1];
    fgcolor[2] += colorstep[2];
  }
  printf("TOTAL time: %lld, average per loop: %lld [microseconds]\n", total, total/loopidx);
  // close
  for (cidx = 0; cidx<numchains; cidx++) {
    close(chainFds[cidx]);
  }
  // free buffer
  free(rawbuffer); rawbuffer = NULL; ledbuffer = NULL;
  // done
  exit(0);
}
