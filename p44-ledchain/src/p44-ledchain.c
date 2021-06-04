/*
 *  p44-ledchain.c - A MT7688 SoC hardware PWM based kernel module for driving addressable smart LEDs (WS28xx, SK68xx, ...)
 *
 *  Copyright (C) 2017-2021 Lukas Zeller <luz@plan44.ch>
 *
 *  This is free software, licensed under the GNU General Public License v2.
 *  See /LICENSE for more information.
 *
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h> // printk()
#include <linux/slab.h> // kzalloc()
#include <linux/uaccess.h> // copy_to_user()
#include <linux/moduleparam.h>
#include <linux/stat.h>

#include <linux/types.h>
#include <linux/string.h>

#include <linux/sched.h>
#include <linux/spinlock.h>
#include <linux/watchdog.h>
#include <linux/ioctl.h>
#include <asm/uaccess.h>
#include <linux/fs.h>

#include <linux/interrupt.h>
#include <linux/irq.h>


// MARK: ===== Global Module definitions

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Lukas Zeller luz@plan44.ch");
MODULE_DESCRIPTION("PWM driver for WS281x, SK68xx type addressable smart led chains for MT7688 SoC");


#define DEVICE_NAME "ledchain"

// Version history
// v1 - unnumbered initial version
// v2 - add LEDCHAIN_PARAM_MAXTPASSIVE to tweak max passive time, mostly for WS2812 where max allowed time varies a lot
// v3 - allow up to 2048 LEDs (previously, only 1024), now shows min/max update duration timer
// v4 - reduce TPassive_max_nS for WS2813/15 to 40uS, more causes occasional flicker for WS2815 at least
// v5 - add ledtype_ws2815_rgb
// v6 - completely reworked led type handling, separate chip/layout parameters, variable mode with led type header in data
#define P44LEDCHAIN_VERSION 6


#define LEDCHAIN_MAX_LEDS 2048
#define DEFAULT_MAX_RETRIES 3
#define MIN_MAXTPASSIVE_NS 5000

#define LOGPREFIX DEVICE_NAME ": "

// MARK: ===== Module Parameter definitions

// parameter array indices
#define LEDCHAIN_PARAM_INVERTED 0 // inverted or not
#define LEDCHAIN_PARAM_NUMLEDS 1 // number of LEDs
#define LEDCHAIN_PARAM_REQUIRED_COUNT 2 // min number of params
#define LEDCHAIN_PARAM_LEDTYPE 2 // type of LEDs
#define LEDCHAIN_PARAM_MAXRETRIES 3 // maximum number of retries in case of timing failures before giving up
#define LEDCHAIN_PARAM_MAXTPASSIVE 4 // maximum number of retries in case of timing failures before giving up
#define LEDCHAIN_PARAM_MAX_COUNT 5 // max number of params


// parameter array storage
static unsigned int ledchain0[LEDCHAIN_PARAM_MAX_COUNT] __initdata;
int ledchain0_argc = 0;
static unsigned int ledchain1[LEDCHAIN_PARAM_MAX_COUNT] __initdata;
int ledchain1_argc = 0;
static unsigned int ledchain2[LEDCHAIN_PARAM_MAX_COUNT] __initdata;
int ledchain2_argc = 0;
static unsigned int ledchain3[LEDCHAIN_PARAM_MAX_COUNT] __initdata;
int ledchain3_argc = 0;

#define LEDCHAIN_PARM_DESC " config: <inverted 0/1>,<numleds>[,<ledtype>[,<maxretries>[,<maxTpassive>]]]"

// parameter declarations
module_param_array(ledchain0, int, &ledchain0_argc, 0000);
MODULE_PARM_DESC(ledchain0, "ledchain@PWM0" LEDCHAIN_PARM_DESC);
module_param_array(ledchain1, int, &ledchain1_argc, 0000);
MODULE_PARM_DESC(ledchain1, "ledchain@PWM1" LEDCHAIN_PARM_DESC);
module_param_array(ledchain2, int, &ledchain2_argc, 0000);
MODULE_PARM_DESC(ledchain2, "ledchain@PMW2" LEDCHAIN_PARM_DESC);
module_param_array(ledchain3, int, &ledchain3_argc, 0000);
MODULE_PARM_DESC(ledchain3, "ledchain@PWM3" LEDCHAIN_PARM_DESC);


// MARK: ===== PWM unit hardware definitions

// - register block
#define MT7688_PWM_BASE 0x10005000L
#define MT7688_PWM_SIZE 0x00000210L
// - access to ioremapped PWM area
void __iomem *pwm_base; // set from ioremap()
#define PWM_ADDR(offset) (pwm_base+offset)
#define PWM_ENABLE        PWM_ADDR(0)
#define PWM_EN_STATUS     PWM_ADDR(0x20C)

// - information about undocumented PWM IRQ in MT7628 found in Android kernel driver in
//   mediatek-android-linux-kerneltree/drivers/misc/mediatek/pwm/mt8173/include/mach/mt_pwm_prv.h
//   Note that the MZ8173/MT6595 PWM is more capable (DMA!) than the MT7688's, but IRQ seems to be
//   the same
#define PWM_INT_ENABLE    PWM_ADDR(0x200) // 8 bits, two bits per channel (ch0=0/1, ch1=2/3), bit 0=PWM_IRQ_FINISH, bit 1=PWM_IRQ_UNDERFLOW
#define PWM_INT_STATUS    PWM_ADDR(0x204) // 8 bits, two bits per channel (ch0=0/1, ch1=2/3), bit 0=PWM_IRQ_FINISH, bit 1=PWM_IRQ_UNDERFLOW
#define PWM_INT_ACK       PWM_ADDR(0x208) // write 1 to acknowledge IRQ
// - information derived from MT7623N datasheet
#define PWM_IRQ_FINISH    0x01 // IRQ that happens when wave is done
#define PWM_IRQ_UNDERFLOW 0x02 // IRQ that happens when new data can be written?


#define PWM_CHAN_OFFS(channel,reg) (0x10+((channel)*0x40)+(reg))
#define PWM_CHAN(channel,reg) PWM_ADDR(PWM_CHAN_OFFS(channel,reg))
#define NUM_DEVICES 4 // number of PWMS = number of devices
// - PWM channel register offsets
#define PWMCON			    0x00
#define PWMHDUR			    0x04
#define PWMLDUR			    0x08
#define PWMGDUR			    0x0c
#define PWMSENDDATA0	  0x20
#define PWMSENDDATA1	  0x24
#define PWMWAVENUM	    0x28
#define PWMDWIDTH		    0x2c
#define PWMTHRES		    0x30
#define PWMSENDWAVENUM  0x34


// set 1 to enable IRQ/TIMER sequence tracing
#define SEQ_TRACING 0

// receiver sequence debug macros
#if SEQ_TRACING
#define SEQ_TRACE_MAX 1000
static char seq_traceinfo[SEQ_TRACE_MAX];
int seq_trace_idx;
#define SEQ_TRACE_CLEAR() { seq_traceinfo[0]=0; seq_trace_idx=0; }
#define SEQ_TRACE(c) { if(seq_trace_idx<SEQ_TRACE_MAX-1) seq_traceinfo[seq_trace_idx++] = c; seq_traceinfo[seq_trace_idx] = 0; }
#define SEQ_TRACE_SHOW() { printk(KERN_INFO LOGPREFIX "sequence trace = %s\n", seq_traceinfo); }
#define SEQ_HEXBYTE(b) { char c; SEQ_TRACE('$'); c = ((b>>4)&0xF)+'0'; if (c>'9') c+=7; SEQ_TRACE(c); c = (b&0xF)+'0'; if (c>'9') c+=7; SEQ_TRACE(c); }
#else
#define SEQ_TRACE_CLEAR()
#define SEQ_TRACE(c)
#define SEQ_HEXBYTE(b)
#define SEQ_TRACE_SHOW()
#endif


// === LED types and their parameters

typedef struct {
  const char *name; ///< name of the LED layout
  int channels; ///< number of channels, 3 or 4
  u8 fetchIdx[4]; ///< fetch indices - at what relative index to fetch bytes from input into output stream
} LedLayoutDescriptor_t;

typedef enum {
  ledlayout_none, ///< if MSB of LEDCHAIN_PARAM_LEDTYPE is set to this, MSB=layout, LSB=chip
  ledlayout_rgb,
  ledlayout_grb,
  ledlayout_rgbw,
  ledlayout_grbw,
  num_ledlayouts
} LedLayout_t;

static const LedLayoutDescriptor_t ledLayoutDescriptors[num_ledlayouts-1] = {
  // RGB data order
  { .name = "RGB", .channels = 3, .fetchIdx = { 0, 1, 2 } },
  // GRB data order
  { .name = "GRB", .channels = 3, .fetchIdx = { 1, 0, 2 } },
  // RGBW data order
  { .name = "RGBW", .channels = 4, .fetchIdx = { 0, 1, 2, 3 } },
  // SK2812 - GRBW data order
  { .name = "GRBW", .channels = 4, .fetchIdx = { 1, 0, 2, 3 } },
};


typedef struct {
  const char *name; ///< name of the LED chip/timing set
  int T0Active_nS; ///< active time for sending a zero bit, such that 2*T0Active_nS are a usable T1Active_nS
  int TPassive_min_nS; ///< minimum time signal must be passive after an active phase
  int T0Passive_double; ///< if set, for a 0 bit the passive time is doubled
  int TPassive_max_nS; ///< max time signal can be passive without reset occurring
  int TReset_nS; ///< time signal must be passive to reset chain
} LedChipDescriptor_t;


typedef enum {
  ledchip_none,
  ledchip_ws2811,
  ledchip_ws2812,
  ledchip_ws2813,
  ledchip_ws2815,
  ledchip_p9823,
  ledchip_sk6812,
  num_ledchips
} LedChip_t;


// Note: time resolution is 25nS (= MT7688 PWM max resolution)
static const LedChipDescriptor_t ledChipDescriptors[num_ledchips-1] = {
  {
    .name = "WS2811",
    // timing from datasheet:
    // - T0H = 350ns..650nS
    // - T0L = 1850ns..2150nS
    // - T1H = 1050ns..1350nS
    // - T1L = 1150ns..1450nS
    // - TReset = >50µS
    .T0Active_nS = 500, .TPassive_min_nS = 1200, .T0Passive_double = 1,
    .TPassive_max_nS = 10000, .TReset_nS = 50000
  },
  {
    .name = "WS2812",
    // timing from datasheet:
    // - T0H = 200ns..500nS
    // - T0L = 750ns..1050nS (actual max is fortunately higher, ~10uS)
    // - T1H = 750ns..1050nS
    // - T1L = 200ns..500nS (actual max is fortunately higher, ~10uS)
    // - TReset = >50µS
    .T0Active_nS = 350, .TPassive_min_nS = 900, .T0Passive_double = 0,
    .TPassive_max_nS = 10000, .TReset_nS = 50000
  },
  {
    .name = "WS2813",
    // timing from datasheet:
    // - T0H = 300ns..450nS
    // - T0L = 300ns..100000nS - NOTE: 300nS is definitely not working, we're using min 650nS instead (proven ok with 200 WS2813)
    // - T1H = 750ns..1000nS
    // - T1L = 300ns..100000nS - NOTE: 300nS is definitely not working, we're using min 650nS instead (proven ok with 200 WS2813)
    // - TReset = >300µS
    .T0Active_nS = 375, .TPassive_min_nS = 650, .T0Passive_double = 0,
    .TPassive_max_nS = 40000, .TReset_nS = 300000
  },
  {
    .name = "WS2815",
    // timing from datasheet:
    // - T0H = 300ns..450nS
    // - T0L = 300ns..100000nS - NOTE: 300nS is definitely not working, we're using min 650nS instead (proven ok with 200 WS2813)
    // - T1H = 750ns..1000nS
    // - T1L = 300ns..100000nS - NOTE: 300nS is definitely not working, we're using min 650nS instead (proven ok with 200 WS2813)
    // - TReset = >300µS
    // - Note: T0L/T1L of more than 35µS can apparently cause single LEDs to reset and loose bits
    .T0Active_nS = 375, .TPassive_min_nS = 650, .T0Passive_double = 0,
    .TPassive_max_nS = 35000, .TReset_nS = 300000
  },
  {
    .name = "P9823",
    // timing from datasheet:
    // - T0H = 200ns..500nS
    // - T0L = 1210ns..1510nS
    // - T1H = 1210ns..1510nS
    // - T1L = 200ns..500nS
    // - TReset = >50µS
    // Note: the T0L and T1H seem to be wrong, using experimentally determined values
    .T0Active_nS = 425, .TPassive_min_nS = 1000, .T0Passive_double = 0,
    .TPassive_max_nS = 10000, .TReset_nS = 50000
  },
  {
    .name = "SK6812",
    // timing from datasheet:
    // - T0H = 150ns..450nS
    // - T0L = 750ns..1050nS (actual max is fortunately higher, ~15uS)
    // - T1H = 450ns..750nS
    // - T1L = 450ns..750nS (actual max is fortunately higher, ~15uS)
    // - TReset = >50µS
    .T0Active_nS = 300, .TPassive_min_nS = 900, .T0Passive_double = 0,
    .TPassive_max_nS = 15000, .TReset_nS = 80000
  },
};


// predefined chip/layout combinations (backwards compatible)

typedef struct {
  LedChip_t chip;
  LedLayout_t layout;
} PredefLedTypeDescriptor_t;

typedef enum {
  // old style fixed type
  ledtype_ws2811,
  ledtype_ws2812,
  ledtype_ws2813,
  ledtype_p9823,
  ledtype_sk6812,
  ledtype_ws2815_rgb,
  num_predef_ledtypes,
  ledtype_variable = 0xFF, ///< LED chip/layout info is included in first two data bytes
  ledtype_chip_mask = 0x00FF, ///< chip part, if layout part is not == ledlayout_none
  ledtype_layout_mask = 0xFF00 ///< layout part, if MSB is not ledlayout_none, LEDCHAIN_PARAM_LEDTYPE directly contains LED chip/layout.
} ParamLedType_t;

// old style fixed types
static const PredefLedTypeDescriptor_t predefLedTypeDescriptors[num_predef_ledtypes] = {
  // WS2811 - RGB data order
  { .chip = ledchip_ws2811, .layout = ledlayout_rgb },
  // WS2812 - GRB data order
  { .chip = ledchip_ws2812, .layout = ledlayout_grb },
  // WS2813, WS2815 - GRB data order
  { .chip = ledchip_ws2813, .layout = ledlayout_grb },
  // P9823 - RGB data order, 5mm/8mm single LEDs
  { .chip = ledchip_p9823, .layout = ledlayout_rgb },
  // SK2812 - GRBW data order
  { .chip = ledchip_sk6812, .layout = ledlayout_grbw },
  // WS2813, WS2815 - RGB data order
  { .chip = ledchip_ws2815, .layout = ledlayout_rgb }
};


// MARK: ===== structs

// PWM pattern
typedef struct {
  u32 data[2];
  u32 nanosecs;
} PWMPattern_t;


// device variables record
struct p44ledchain_dev {
  // configuration
  // - PWM channel number (0..3)
  int pwm_channel;
  // - inverted signal?
  int inverted;
  // - predefined LED chip and layout types
  LedChip_t chipType;
  LedLayout_t layoutType;
  // - current LED layout
  const LedChipDescriptor_t *ledChipDesc;
  // - current LED chip
  const LedLayoutDescriptor_t *ledLayoutDesc;
  // - max TPassive time in nS (default comes from led chip descriptor, but is tweakable)
  int maxTPassiveNs;
  // - number of LEDs
  int num_leds;
  // - max sending repeats
  int maxSendRetries;
  // the device
  struct cdev cdev;
  // spinlock for updating hardware
  spinlock_t updatelock;
  // HR timer to restart sending
  struct hrtimer starttimer;
  // output buffer
  PWMPattern_t *outBuf;
  u32 outBufSize;
  // - buffer pointer for generating or sending
  PWMPattern_t *outPtr;
  // - number of 64-bit patterns in the Buffer (=entire chain data)
  u32 numPWMPatterns;
  u32 nextPWMPatterns; // next scheduled number of patterns
  // - number of patterns left to send
  u32 remainingPWMPatterns;
  // - pattern generator vars
  u32 outMask;
  u32 bitCount;
  u32 nanosecs;
  // read index
  size_t read_idx;
  // timing
  int notReady; // set as long as no new send can be started
  long long expectedSentAt; // time when last 64bits are expected to be fully sent (checked in IRQ to detect timing violations)
  int sendRetries; // how many times sending was tried
  // statistics
  long long updateStartedAt; // time when last update was started
  u32 max_irq_delay; // max IRQ delay behind expectedSentAt that did NOT trigger a retry
  u32 min_irq_delay; // min IRQ delay behind expectedSentAt seen
  u32 last_timeout_ns; // last IRQ delay that triggered a retry
  u32 irq_count; // IRQ counter
  u32 updates; // number of updates requested
  u32 retries; // number of retries
  u32 errors; // number of failed updates
  u32 overruns; // number of updates which came while another update was still in progress
  u32 last_update_us; // time it took for the last complete update
  u32 min_update_us; // min time for a complete update
  u32 max_update_us; // max time for a complete update
};
typedef struct p44ledchain_dev *devPtr_t;


// MARK: ===== static (module global) vars

// the IRQ number of the PWM_EN_STATUS
static int pwm_irq_no;

// the device class
static struct class *p44ledchain_class = NULL;

// the device major number
int p44ledchain_major;

// the devices stored by PWM channel, as we need this to find back device in IRQ handler
static devPtr_t p44ledchain_devices[NUM_DEVICES];



// MARK: ===== PWM data sending

// prototypes
static u32 sendNextPattern(devPtr_t dev);
static void sendFirstPattern(devPtr_t dev);
static void startSendingPatterns(devPtr_t dev);



// IRQs blocked!
u32 sendNextPattern(devPtr_t dev)
{
  u32 expectedNs = 0;

  SEQ_TRACE('p');
  // disable PWM before setting new pattern (especially in case no more patterns follow!)
  iowrite32(ioread32(PWM_ENABLE) & ~(1<<dev->pwm_channel), PWM_ENABLE);
  if (dev->remainingPWMPatterns>0) {
    // set new pattern to send
    iowrite32(dev->outPtr->data[0], PWM_CHAN(dev->pwm_channel, PWMSENDDATA0)); // Upper 32 bits
    iowrite32(dev->outPtr->data[1], PWM_CHAN(dev->pwm_channel, PWMSENDDATA1)); // Lower 32 bits
    // get nanoseconds
    expectedNs = dev->outPtr->nanosecs;
    // next
    (dev->outPtr)++;
    (dev->remainingPWMPatterns)--;
    iowrite32(ioread32(PWM_ENABLE) | (1<<dev->pwm_channel), PWM_ENABLE); // (re)enable PWM
    SEQ_TRACE('s');
  }
  return expectedNs; // 0 if done, >0 how many nSecs sending this wave will take
}


// IRQs blocked!
void sendFirstPattern(devPtr_t dev)
{
  u32 expectedNs;

  SEQ_TRACE('P');
  // start at beginning of data
  dev->outPtr = dev->outBuf;
  dev->remainingPWMPatterns = dev->numPWMPatterns;
  // start
  expectedNs = sendNextPattern(dev);
  if (expectedNs) {
    // something sent, update expected time
    dev->expectedSentAt = ktime_to_ns(ktime_get())+expectedNs;
    SEQ_TRACE('S');
  }
  else {
    SEQ_TRACE('0');
    // nothing to send, no need to wait for chain to reset
    dev->numPWMPatterns = 0;
  }
}


// IRQs blocked!
void startSendingPatterns(devPtr_t dev)
{
  SEQ_TRACE('B');
  dev->numPWMPatterns = dev->nextPWMPatterns;
  dev->nextPWMPatterns = 0; // used now
  // init the PWM
  // - disable the PWM
  iowrite32(ioread32(PWM_ENABLE) & ~(1<<dev->pwm_channel), PWM_ENABLE); // disable PWM
  // - set up the PWM for new pattern
  if (dev->numPWMPatterns>0) {
    u32 intEnable;
    SEQ_TRACE('>');
    dev->updates++;
    dev->notReady = 1;
    dev->sendRetries = 0;
    dev->last_timeout_ns = 0;
    dev->last_update_us = 0;
    dev->max_irq_delay = 0;
    dev->min_irq_delay = dev->maxTPassiveNs;
    dev->updateStartedAt = ktime_to_ns(ktime_get());
    // - enable PWM IRQ
    intEnable = ioread32(PWM_INT_ENABLE); // currently enabled PWM IRQs
    SEQ_HEXBYTE(intEnable);
    iowrite32(intEnable | (PWM_IRQ_FINISH<<(dev->pwm_channel*2)), PWM_INT_ENABLE); // enable underflow interrupt for this channel
    // - set up PWM for one output sequence
    iowrite32(0x7E08 | (dev->inverted ? 0x0180 : 0x0000), PWM_CHAN(dev->pwm_channel, PWMCON)); // PWMxCON: New PWM mode, all 64 bits, idle&guard=inverted, 40Mhz clock, no clock dividing
    iowrite32(dev->ledChipDesc->T0Active_nS/25, PWM_CHAN(dev->pwm_channel, dev->inverted ? PWMLDUR : PWMHDUR)); // bit active time
    iowrite32(dev->ledChipDesc->TPassive_min_nS/25, PWM_CHAN(dev->pwm_channel, dev->inverted ? PWMHDUR : PWMLDUR)); // bit passive time
    iowrite32(0, PWM_CHAN(dev->pwm_channel, PWMGDUR)); // no guard time
    iowrite32(1, PWM_CHAN(dev->pwm_channel, PWMWAVENUM)); // one single wave at a time
    // - initiate sending
    sendFirstPattern(dev);
  }
}


static enum hrtimer_restart p44ledchain_timer_func(struct hrtimer *timer)
{
  devPtr_t dev = container_of(timer, struct p44ledchain_dev, starttimer);
  unsigned long irqflags;

  spin_lock_irqsave(&dev->updatelock, irqflags);
  SEQ_TRACE(' ');
  SEQ_TRACE('T');
  SEQ_TRACE('0'+dev->pwm_channel);
  if (dev->notReady) {
    SEQ_TRACE('!');
    // still in progress
    if (dev->remainingPWMPatterns) {
      // timer hitting in notReady with remaining patterns means we must retry entire sequence
      sendFirstPattern(dev);
    }
    else {
      // timer hitting in notReady with NO patterns left means we become ready now
      dev->notReady = 0;
      // if there are new patterns, start sending those now
      startSendingPatterns(dev);
    }
  }
  SEQ_TRACE(' ');
  spin_unlock_irqrestore(&dev->updatelock, irqflags);
  // done
  return HRTIMER_NORESTART;
}


static irqreturn_t p44ledchain_pwm_interrupt(int irq, void *dev_id)
{
  unsigned long irqflags;
  long long now;
  u32 expectedNs;
  u32 irqStatus;
  u32 irqMask;
  u32 irq_delay_ns;
  int i;
  irqreturn_t ret = IRQ_NONE;
  devPtr_t dev;

  local_irq_save(irqflags);
  SEQ_TRACE(' ');
  SEQ_TRACE('I');
  irqStatus = ioread32(PWM_INT_STATUS); // two bits per channel
  SEQ_HEXBYTE(irqStatus);
  now = ktime_to_ns(ktime_get());
  irqMask = PWM_IRQ_FINISH;
  for (i=0; i<NUM_DEVICES; i++) {
    // IRQ from this PWM?
    if (irqStatus & irqMask) {
      SEQ_TRACE('i');
      dev = ((devPtr_t *)dev_id)[i];
      if (dev) {
        SEQ_TRACE('d');
        SEQ_TRACE('0'+i);
        // PWM channel i has interrupt and we have a ledchain device for that channel
        // - acknowledge the IRQ
        iowrite32(irqMask, PWM_INT_ACK);
        // check for timing failure
        irq_delay_ns = now-dev->expectedSentAt;
        if (irq_delay_ns > dev->maxTPassiveNs) {
          // failure, needs retry
          SEQ_TRACE('o');
          dev->sendRetries++;
          dev->retries++;
          dev->last_timeout_ns = irq_delay_ns;
          if (dev->sendRetries>=dev->maxSendRetries) {
            // give up, do not restart when timer hits
            SEQ_TRACE('E');
            dev->remainingPWMPatterns = 0; // do not attempt to send anything more
            dev->errors++; // count the errors
          }
          // - start timer to either hold back next update or retry sending
          hrtimer_start(&dev->starttimer, ktime_set(0, (dev->ledChipDesc->TReset_nS)/2*3), HRTIMER_MODE_REL);
        }
        else {
          // send next
          SEQ_TRACE('n');
          if (irq_delay_ns<dev->min_irq_delay) {
            dev->min_irq_delay = irq_delay_ns;
          }
          else if (irq_delay_ns>dev->max_irq_delay) {
            dev->max_irq_delay = irq_delay_ns;
          }
          expectedNs = sendNextPattern(dev);
          if (expectedNs) {
            // something to send, update expected time
            dev->expectedSentAt = now+expectedNs;
            SEQ_TRACE('w');
          }
          else {
            // nothing more to send
            SEQ_TRACE('W');
            // - completely and successfully written out
            dev->numPWMPatterns = 0;
            dev->last_update_us = ((now-dev->updateStartedAt)*131)>>17; // poor man's division by 1000: multiply by 2^17/1000, cut 17 LSBs
            if (dev->last_update_us>dev->max_update_us) dev->max_update_us = dev->last_update_us;
            if (dev->last_update_us<dev->min_update_us) dev->min_update_us = dev->last_update_us;
            // - start timer to know when chain reset time is over and next update can be started immediately
            hrtimer_start(&dev->starttimer, ktime_set(0, (dev->ledChipDesc->TReset_nS)/2*3), HRTIMER_MODE_REL);
          }
          // statistics
          dev->irq_count++;
        }
        ret = IRQ_HANDLED;
      }
    }
    // next PWM channel
    irqMask <<= 2;
  }
  SEQ_TRACE(' ');
  local_irq_restore(irqflags);
  // return handled status
  return ret;
}


// MARK: ===== Control sending patterns


// Call before preparing new patterns into the buffer
static int stopSendingPatterns(devPtr_t dev)
{
  int nrdy;
  unsigned long irqflags;

  spin_lock_irqsave(&dev->updatelock, irqflags);
  SEQ_TRACE('X');
  nrdy = dev->notReady;
  SEQ_TRACE('0'+nrdy);
  // prevent any more pattern sending
  dev->remainingPWMPatterns = 0;
  dev->numPWMPatterns = 0;
  dev->nextPWMPatterns = 0;
  // now when IRQ or timer hits, nothing will happen except notReady cleared
  spin_unlock_irqrestore(&dev->updatelock, irqflags);
  return nrdy;
}


// Call when new patterns are ready in the buffer to be sent
static void scheduleNewPatterns(u32 aNumNewPatterns, devPtr_t dev)
{
  unsigned long irqflags;

  SEQ_TRACE('N');
  spin_lock_irqsave(&dev->updatelock, irqflags);
  // set number of new patterns
  dev->nextPWMPatterns = aNumNewPatterns;
  if (!dev->notReady) {
    // fully ready, need to initiate now
    // (otherwise, timer will initiate it when it hits)
    startSendingPatterns(dev);
  }
  spin_unlock_irqrestore(&dev->updatelock, irqflags);
}


static int isReady(devPtr_t dev)
{
  int nrdy;
  unsigned long irqflags;

  spin_lock_irqsave(&dev->updatelock, irqflags);
  nrdy = dev->notReady;
  spin_unlock_irqrestore(&dev->updatelock, irqflags);
  return !nrdy;
}


// MARK: ===== Generating new patterns

#define VAR_DUMP 0

// init generating bits
static void initBitGenerator(devPtr_t dev)
{
  dev->remainingPWMPatterns = 0; // nothing ready to send yet, will also halt currently running send
  dev->outPtr = dev->outBuf; // start at beginning of buffer
  dev->outMask = 0;
  dev->bitCount = 0;
  dev->nanosecs = 0;
}


// generate single bit into pattern buffer
static void generateBit(int aBit, devPtr_t dev)
{
  u32 om = dev->outMask;
  u32 *owPtr = &(dev->outPtr->data[(dev->bitCount & 0x20) ? 1 : 0]); // second word for bits 32..63

  #if VAR_DUMP
  printk(KERN_INFO LOGPREFIX "bit=%d, outPtr=0x%08X, om=0x%08X, bitCount=%d, *owPtr=0x%08X, nanosecs=%d\n", aBit, (u32)(dev->outPtr), om, dev->bitCount, *owPtr, dev->nanosecs);
  #endif

  if (om==0) {
    om=1L; // fill LSB first
    *owPtr = 0; // init next buffer word
  }
  if (aBit!=dev->inverted) {
    // set output bit high
    *owPtr = *owPtr | om;
  }
  else {
    // set output bit low
    *owPtr = *owPtr & ~om;
  }
  // update nanoseconds
  if (aBit)
    dev->nanosecs += dev->ledChipDesc->T0Active_nS;
  else
    dev->nanosecs += dev->ledChipDesc->TPassive_min_nS;
  // next bit
  om = om << 1;
  (dev->bitCount)++;
  if (om==0) {
    // longword complete, begin next
    if (dev->bitCount>=64) {
      // 64 bit pattern complete, save nanoseconds
      dev->outPtr->nanosecs = dev->nanosecs;
      dev->nanosecs = 0;
      dev->bitCount = 0;
      // safeguard
      if (dev->outPtr-dev->outBuf>=dev->outBufSize) {
        printk(KERN_WARNING LOGPREFIX "output buffer exhaused (should not happen)\n");
      }
      else {
        (dev->outPtr)++;
      }
    }
  }
  dev->outMask = om;
}


// generate bit pattern to be fed into PWM engine from input data word
static void generateBits(u32 aWord, u8 aNumBits, devPtr_t dev)
{
  u32 inMask = 1L<<(aNumBits-1);
  int bit;
  while (aNumBits>0) {
    // generate next bit
    bit = (aWord & inMask) != 0;
    // make sure 1-bit does not start at end of a 64-bit word
    if (bit && (dev->bitCount==63)) {
      // High bit starting at end of 64bit output word -> would fail because cut in two parts by idle period
      generateBit(0, dev); // insert an extra inactive period, so High bit is in fresh 64-bit word
    }
    generateBit(1, dev); // first bit always high
    if (bit) generateBit(1, dev); // generate a second high period for a high input bit
    // idle period is only needed if not in a new pattern (pattern load time is assumed to be ALWAYS longer than minimal idle period!)
    if (dev->bitCount!=0) {
      generateBit(0, dev); // at least one low period is needed
      if (!bit && dev->ledChipDesc->T0Passive_double && dev->bitCount!=0) {
        // 0-bit needs double passive time (but is not needed if we're at end of the pattern)
        generateBit(0, dev); // add another low bit
      }
    }
    // shift input bit mask to next bit
    inMask = inMask>>1;
    // bit done
    aNumBits--;
  }
}


// finish bit generation, fill up last 64-bit PWM word
static u32 finishBitGenerator(devPtr_t dev)
{
  u32 *owPtr;
  // fill up to next 64bit
  if (dev->bitCount!=0) {
    // fill up current 32bit word
    owPtr = &(dev->outPtr->data[(dev->bitCount & 0x20) ? 1 : 0]); // second word for bits 32..63
    if (dev->outMask!=0) {
      while (dev->outMask!=0) {
        if (dev->inverted)
          *owPtr |= (dev->outMask);
        else
          *owPtr &= ~(dev->outMask);
        (dev->bitCount)++;
        dev->nanosecs += dev->ledChipDesc->TPassive_min_nS;
        dev->outMask = dev->outMask << 1;
      }
    }
    // test if still not 64 bits
    if ((dev->bitCount & 0x3F)!=0) {
      // need a dummy word to fill up
      dev->outPtr->data[1] = dev->inverted ? 0xFFFFFFFF : 0x0;
      dev->bitCount += 32;
      dev->nanosecs += 32*dev->ledChipDesc->TPassive_min_nS;
    }
    // word full now, save nanosecs and advance
    dev->outPtr->nanosecs = dev->nanosecs;
    (dev->outPtr)++;
  }
  // return number of new patterns
  return dev->outPtr - dev->outBuf;
}


// MARK: ===== Update led chain with new data

#define DATA_DUMP 0 // data input and output dump
#define STAT_INFO 0 // statistic info dump for every update


void update_leds(const char *buff, size_t len, devPtr_t dev)
{
  LedChip_t chipType;
  LedLayout_t layoutType;
  u32 ledword;
  int leds;
  int ncomp;
  int i;
  int hdrlen;
  u8 *inPtr;
  u32 newPatterns;
  #if DATA_DUMP
  int k;
  int idx;
  #endif

  // make sure current sending is aborted
  if (stopSendingPatterns(dev)) {
    // was not ready yet
    dev->overruns++;
    #if STAT_INFO
    printk(KERN_INFO LOGPREFIX "#%d: was still busy sending data -> aborted and start again with new data\n", dev->pwm_channel);
    #endif
  }
  // check for variable LED type mode
  if (dev->layoutType==ledlayout_none) {
    // first byte is the header length
    if (len>0) hdrlen = buff[0];
    // v6 header has 5 data bytes. Future versions might have more
    if (hdrlen<5 || len<hdrlen+1) {
      printk(KERN_WARNING LOGPREFIX "#%d: invalid LED header (less than 6 bytes)\n", dev->pwm_channel);
      return;
    }
    else {
      // process v6 type header:
      // ll cc pppp rr (ll = layout, cc = chip, pppp = max TPassive in uSec or 0 for default), rr = retries (0 for default)
      layoutType = (LedLayout_t)buff[1];
      chipType = (LedChip_t)buff[2];
      if (chipType==0 || chipType>=num_ledchips || layoutType==0 || layoutType>=num_ledlayouts) {
        printk(KERN_WARNING LOGPREFIX "#%d: invalid LED type\n", dev->pwm_channel);
        return;
      }
      // set led type and layout descriptor pointers for this run
      dev->ledChipDesc = &ledChipDescriptors[chipType-1];
      dev->ledLayoutDesc = &ledLayoutDescriptors[layoutType-1];
      // also take max passive time from header
      dev->maxTPassiveNs = ( ((u8)buff[3]<<8) + (u8)buff[4] )*1000; // uS -> nS
      // optionally use different send retry count
      if (buff[5]!=0) {
        dev->maxSendRetries = buff[5];
      }
      // header processed
      #if DATA_DUMP
      printk(
        KERN_INFO LOGPREFIX "led type in header: %s %s, custom maxTPassiveNs = %ld, maxSendRetries = %d\n",
        dev->ledChipDesc->name,  dev->ledLayoutDesc->name, dev->maxTPassiveNs, dev->maxSendRetries
      );
      #endif
      buff += hdrlen+1;
      len -= hdrlen+1;
    }
  }
  if (dev->maxTPassiveNs==0) dev->maxTPassiveNs = dev->ledChipDesc->TPassive_max_nS; // 0 = use chip's  default
  // calculate number of LEDs
  ncomp = dev->ledLayoutDesc->channels;
  leds = len/ncomp;
  // limit to max
  if (leds>dev->num_leds) leds=dev->num_leds;
  #if STAT_INFO
  printk(KERN_INFO LOGPREFIX "#%d: Received %d bytes -> data for %d LEDs with %d bytes each\n", dev->pwm_channel, len, leds, ncomp);
  #endif
  inPtr = (u8 *)buff;
  #if DATA_DUMP
  // show LED input data
  for (idx=0, k=0; k<leds; k++) {
    if (ncomp==4) {
      printk(KERN_INFO LOGPREFIX "RGBW LED#%03d : R=%3d, G=%3d, B=%3d, W=%3d\n", k, inPtr[idx], inPtr[idx+1], inPtr[idx+2], inPtr[idx+3]);
    }
    else {
      printk(KERN_INFO LOGPREFIX "RGB LED#%03d : R=%3d, G=%3d, B=%3d\n", k, inPtr[idx], inPtr[idx+1], inPtr[idx+2]);
    }
    idx += ncomp;
  }
  #endif
  // generate data into buffer
  initBitGenerator(dev);
  // generate bits into buffer
  while (leds>0) {
    i = 0;
    ledword = 0;
    while (true) {
      ledword |= inPtr[dev->ledLayoutDesc->fetchIdx[i]];
      i++;
      if (i>=ncomp)
        break;
      ledword <<= 8;
    }
    generateBits(ledword, ncomp*8, dev);
    inPtr += ncomp;
    // next LED
    leds--;
  }
  // finish bit generation
  newPatterns = finishBitGenerator(dev);
  #if STAT_INFO
  printk(KERN_INFO LOGPREFIX "number of 64-bit patterns to send=%u\n", newPatterns);
  #endif
  #if DATA_DUMP
  for (k=0; k<newPatterns; k++) {
    printk(
      KERN_INFO LOGPREFIX "pattern #%d : 0x%08X 0x%08X - %u nS\n",
      k, dev->outBuf[k].data[0], dev->outBuf[k].data[1], dev->outBuf[k].nanosecs
    );
  }
  #endif
  // information
  SEQ_TRACE_SHOW()
  #if STAT_INFO
  printk(
    KERN_INFO LOGPREFIX "#%d: Previous update had %d retries, last timeout=%unS, min..max irq=%u..%unS, duration=%u..%uuS\n",
    dev->pwm_channel, dev->sendRetries, dev->last_timeout_ns, dev->min_irq_delay, dev->max_irq_delay, dev->last_update_us
  );
  printk(
    KERN_INFO LOGPREFIX "#%d: Totals: updates=%u, overruns=%u, retries=%u, errors=%u, irqs=%u\n",
    dev->updates, dev->overruns, dev->retries, dev->errors, dev->irq_count
  );
  #else
  if (dev->sendRetries>dev->maxSendRetries) {
    printk(
      KERN_INFO LOGPREFIX "#%d: Previous update failed (%d repeats) - Totals: updates=%u, retries=%u, errors=%u, irqs=%u\n",
      dev->pwm_channel, dev->sendRetries, dev->updates, dev->retries, dev->errors, dev->irq_count
    );
  }
  #endif
  // start sending now or schedule start when reset time is over
  SEQ_TRACE_CLEAR()
  scheduleNewPatterns(newPatterns, dev);
}


// MARK: ===== character device file operations

// prototypes
static int p44ledchain_open(struct inode *, struct file *);
static int p44ledchain_release(struct inode *, struct file *);
static ssize_t p44ledchain_read(struct file *, char *, size_t, loff_t *);
static ssize_t p44ledchain_write(struct file *, const char *, size_t, loff_t *);

// file access handlers
static struct file_operations p44ledchain_fops = {
  .open = p44ledchain_open,
  .release = p44ledchain_release,
  .read = p44ledchain_read,
  .write = p44ledchain_write,
};


static int p44ledchain_open(struct inode *inode, struct file *filp)
{
  devPtr_t dev = container_of(inode->i_cdev, struct p44ledchain_dev, cdev);
  // remember our dev in the filp
  filp->private_data = (void *)dev;
  dev->read_idx = 0;
  return 0;
}


static int p44ledchain_release(struct inode *inode, struct file *filp)
{
  // NOP
  return 0;
}


static ssize_t p44ledchain_read(struct file *filp, char *buf, size_t count, loff_t *f_pos)
{
  const int ansBufferSize = 512;
  char ans[ansBufferSize];
  size_t bytes = 0;
  devPtr_t dev = (devPtr_t)filp->private_data;
  const char *ansP;

  // return "Ready" or "Busy" on first line, some stats on following lines
  bytes = snprintf(ans, ansBufferSize,
    "%s\n"
    "Last update: %d retries, last timeout=%dnS, min..max irq=%u..%unS, duration=%uuS\n"
    "Totals: updates=%u, overruns=%u, retries=%u, errors=%u, irqs=%u, min..max update duration=%u..%uuS\n",
    isReady(dev) ? "Ready" : "Busy",
    dev->sendRetries, dev->last_timeout_ns, dev->min_irq_delay, dev->max_irq_delay, dev->last_update_us,
    dev->updates, dev->overruns, dev->retries, dev->errors, dev->irq_count, dev->min_update_us, dev->max_update_us
  );
  if (bytes<=0 || dev->read_idx>=bytes) {
    // all data read already before -> create an EOF conditon for now
    bytes = 0;
    dev->read_idx = 0; // next read will again return the entire answer
  }
  else {
    // not all bytes read yet
    bytes -= dev->read_idx; // don't return already read bytes again
    ansP = ans + dev->read_idx;
    // limit to amount requested
    if (bytes>count) {
      bytes = count;
    }
    // update reading index
    dev->read_idx += bytes;
    // now copy to user, which can sleep
    copy_to_user(buf, ansP, bytes);
  }
  return bytes;
}


static ssize_t p44ledchain_write(struct file *filp, const char *buff, size_t len, loff_t * off)
{
  devPtr_t dev = (devPtr_t)filp->private_data;

  update_leds(buff, len, dev);
  return len;
}


// MARK: ===== device init and cleanup


static int p44ledchain_add_device(struct class *class, int minor, devPtr_t *devP, unsigned int *params, int param_count, const char *devname)
{
  int err;
  int pval;
	struct device *device = NULL;
	devPtr_t dev = NULL;
	u16 ltyp;

	BUG_ON(class==NULL || devP==NULL);

  // no dev created yet
  *devP = NULL;
  // check param count
  if (param_count<LEDCHAIN_PARAM_REQUIRED_COUNT) {
    printk(KERN_WARNING LOGPREFIX "not enough parameters for %s\n", devname);
    err = -EINVAL;
    goto err;
  }
  // create device variables struct
  dev = kzalloc(sizeof(*dev), GFP_KERNEL);
  if (!dev) {
    err = -ENOMEM;
    goto err;
  }
  // assign PWM channel no = minor devno
  dev->pwm_channel = minor;
  // parse the params
  // - invert flag
  dev->inverted = params[LEDCHAIN_PARAM_INVERTED]!=0;
  // - number of LEDs
  pval = params[LEDCHAIN_PARAM_NUMLEDS];
  if (pval<1 || pval>LEDCHAIN_MAX_LEDS) {
    printk(KERN_WARNING LOGPREFIX "Number of LEDs must be 1..%d for %s\n", LEDCHAIN_MAX_LEDS, devname);
    err = -EINVAL;
    goto err_free;
  }
  dev->num_leds = pval;
  // - LED type: can be either:
  //   - MSB==0 -> LSB=one of the old predefined types
  //   - MSB!=0 -> MSB=layout, LSB=chip
  ltyp = ledtype_ws2812; // standard
  if (LEDCHAIN_PARAM_LEDTYPE<param_count) {
    ltyp = (u16)params[LEDCHAIN_PARAM_LEDTYPE];
    if ((ltyp&ledtype_layout_mask)!=0) {
      // direct specification of layout and type
      dev->layoutType = (ltyp&ledtype_layout_mask)>>8;
      dev->chipType = ltyp&ledtype_chip_mask;
      if (dev->layoutType>=num_ledlayouts) {
        printk(KERN_WARNING LOGPREFIX "MSB of LED type is layout type and must be 1..%d for %s\n", num_ledlayouts-1, devname);
        err = -EINVAL;
        goto err_free;
      }
      else if (dev->chipType==0 || dev->chipType>=num_ledchips) {
        printk(KERN_WARNING LOGPREFIX "LSB of LED type is chip type and must be 1..%d for %s\n", num_ledchips-1, devname);
        err = -EINVAL;
        goto err_free;
      }
    }
    else {
      // indirect specification of layout and type via legacy led types
      if (ltyp==ledtype_variable) {
        dev->layoutType = ledlayout_none; // signals layout+chip are determined by data for every update
      }
      else {
        if (ltyp>=num_predef_ledtypes) {
          printk(KERN_WARNING LOGPREFIX "LED type must be 0..%d or 255 for %s\n", num_predef_ledtypes-1, devname);
          err = -EINVAL;
          goto err_free;
        }
        dev->layoutType = predefLedTypeDescriptors[ltyp].layout;
        dev->chipType = predefLedTypeDescriptors[ltyp].chip;
      }
    }
  }
  if (dev->layoutType!=ledlayout_none) {
    // led type and layout is fixed for the device, can set descriptor pointers now
    dev->ledChipDesc = &ledChipDescriptors[dev->chipType-1];
    dev->ledLayoutDesc = &ledLayoutDescriptors[dev->layoutType-1];
  }
  // - retries
  dev->maxSendRetries = DEFAULT_MAX_RETRIES;
  if (LEDCHAIN_PARAM_MAXRETRIES<param_count) {
    pval = params[LEDCHAIN_PARAM_MAXRETRIES];
    if (pval<0) {
      printk(KERN_WARNING LOGPREFIX "max retries must be >=0 for %s\n", devname);
      err = -EINVAL;
      goto err_free;
    }
    dev->maxSendRetries = pval;
  }
  // - max passive time
  dev->maxTPassiveNs = 0; // indicates no custom value set
  if (LEDCHAIN_PARAM_MAXTPASSIVE<param_count) {
    pval = params[LEDCHAIN_PARAM_MAXTPASSIVE];
    if (pval<MIN_MAXTPASSIVE_NS) {
      printk(KERN_WARNING LOGPREFIX "max passive time < %dnS is unlikely to work for %s\n", MIN_MAXTPASSIVE_NS, devname);
    }
    dev->maxTPassiveNs = pval;
  }
  // allocate the buffer for the LED data
  dev->outBufSize =
    dev->num_leds // = number of leds
    * (dev->ledLayoutDesc ? dev->ledLayoutDesc->channels : 4) // * channels (always assume 4 in case of variable layout)
    * 8 // * number of bits = number of LED bits to send max
    * 3 // * number of PWM bits per payload bits (max) = number of PWM bits total
    / 64 // number of PWM patterns
    * sizeof(PWMPattern_t);
  dev->outBuf = kzalloc(dev->outBufSize, GFP_KERNEL);
  if (!dev->outBuf) {
    printk(KERN_WARNING LOGPREFIX "Cannot allocate PWM data buffer of %d bytes for %s\n", dev->outBufSize, devname);
    err = -ENOMEM;
    goto err_free;
  }
  // register cdev
  // - init the struct contained in our dev struct
  cdev_init(&dev->cdev, &p44ledchain_fops);
  dev->cdev.owner = THIS_MODULE;
  // - add one device starting at devno (major+minor)
  err = cdev_add(&dev->cdev, MKDEV(p44ledchain_major, minor), 1);
  if (err) {
    printk(KERN_WARNING LOGPREFIX "Error adding cdev, err=%d\n", err);
    goto err_free_buffer;
  }
  // create device
  device = device_create(
    class, NULL, // no parent device
		MKDEV(p44ledchain_major, minor), NULL, // no additional data
		devname // device name (format string + more params are allowed)
	);
	if (IS_ERR(device)) {
		err = PTR_ERR(device);
		printk(KERN_WARNING LOGPREFIX "Error %d while trying to create %s\n", err, devname);
		goto err_free_cdev;
	}
  // init the lock
  spin_lock_init(&dev->updatelock);
  // init the timer
  hrtimer_init(&dev->starttimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
  dev->starttimer.function = p44ledchain_timer_func;
  // init update time statistics
  dev->max_update_us = 0;
  dev->min_update_us = 10000000; // ten seconds
  // Config summary
  printk(KERN_INFO LOGPREFIX "v%d - Device: /dev/%s\n", P44LEDCHAIN_VERSION, devname);
  printk(KERN_INFO LOGPREFIX "- PWM channel    : %d\n", dev->pwm_channel);
  printk(KERN_INFO LOGPREFIX "- PWM buffer size: %u\n", dev->outBufSize);
  printk(KERN_INFO LOGPREFIX "- Number of LEDs : %d\n", dev->num_leds);
  printk(KERN_INFO LOGPREFIX "- Inverted       : %d\n", dev->inverted);
  printk(KERN_INFO LOGPREFIX "- LED type       : %s %s\n", (dev->ledChipDesc ? dev->ledChipDesc->name : "<variable>"), (dev->ledLayoutDesc ? dev->ledLayoutDesc->name : ""));
  printk(KERN_INFO LOGPREFIX "- Max retries    : %d\n", dev->maxSendRetries);
  printk(KERN_INFO LOGPREFIX "- Max Tpassive   : %d nS (0=chip default)\n", dev->maxTPassiveNs);
  // done
  *devP = dev; // pass back new dev
  return 0;
// wind-down after error
err_free_cdev:
  cdev_del(&dev->cdev);
err_free_buffer:
  kfree(dev->outBuf);
err_free:
  kfree(dev);
err:
  return err;
}


static void p44ledchain_remove_device(struct class *class, int minor, devPtr_t *devP)
{
  devPtr_t dev;
  u32 intEnable;

	BUG_ON(class==NULL || devP==NULL);
  dev = *devP;
  if (!dev) return; // no device to remove
	// cancel sending
	stopSendingPatterns(dev);
	hrtimer_cancel(&dev->starttimer);
	// disable PWM interrupts
  intEnable = ioread32(PWM_INT_ENABLE); // currently enabled PWM IRQs
  iowrite32(intEnable & ~((PWM_IRQ_FINISH|PWM_IRQ_UNDERFLOW)<<(dev->pwm_channel*2)), PWM_INT_ENABLE); // disable interrupts of this channel
	// destroy device
	device_destroy(class, MKDEV(p44ledchain_major, minor));
	// delete cdev
	cdev_del(&dev->cdev);
	// delete buffer
  kfree(dev->outBuf);
  // delete dev
  kfree(dev);
  *devP = NULL;
	return;
}


// MARK: ===== module init and exit


static int __init p44ledchain_init_module(void)
{
  int err;
  int i;
  dev_t devno;

  SEQ_TRACE_CLEAR()
  // no devices to begin with
  for (i=0; i<NUM_DEVICES; i++) {
    p44ledchain_devices[i] = NULL;
  }
  // at least one device needs to be defined
  if (ledchain0_argc+ledchain1_argc+ledchain2_argc+ledchain3_argc==0) {
    printk(KERN_WARNING LOGPREFIX "must specify at least one PWM driven LED chain\n");
		err = -EINVAL;
		goto err;
  }
	// Get a range of minor numbers (starting with 0) to work with */
	err = alloc_chrdev_region(&devno, 0, NUM_DEVICES, DEVICE_NAME);
	if (err < 0) {
		printk(KERN_WARNING LOGPREFIX "alloc_chrdev_region() failed\n");
		return err;
	}
	p44ledchain_major = MAJOR(devno);
	// Create device class
	p44ledchain_class = class_create(THIS_MODULE, DEVICE_NAME);
	if (IS_ERR(p44ledchain_class)) {
		err = PTR_ERR(p44ledchain_class);
		goto err_unregister_region;
	}
  // map PWM registers
  // TODO: should also do request_mem_region()
  pwm_base = ioremap(MT7688_PWM_BASE, MT7688_PWM_SIZE);
  printk(KERN_INFO DEVICE_NAME": pwm_base=0x%08X\n", (u32)pwm_base);
  // request the IRQ
  // FIXME: for now, we just KNOW the IRQ
  pwm_irq_no = 8+26; // Undocumented in MT7688 datasheet, but is same as mentioned in MT7628 datasheet IRQ channel table (8=CPU IRQ offset, 26=IRQ number in interrupt controller)
  err = request_any_context_irq(
    pwm_irq_no,
    p44ledchain_pwm_interrupt,
    IRQF_SHARED , // the IRQ is shared between all PWM channels
    "pwm-irq",
    p44ledchain_devices // array of all 4 possible devices
  );
  if (err!=IRQC_IS_HARDIRQ) {
    printk(KERN_WARNING LOGPREFIX "registering IRQ %d failed (or not hardIRQ) for PWM, err=%d\n", pwm_irq_no, err);
    goto err_unmap;
  }
  // instantiate devices from module params
  if (ledchain0_argc>0) {
    err = p44ledchain_add_device(p44ledchain_class, 0, &(p44ledchain_devices[0]), ledchain0, ledchain0_argc, "ledchain0");
    if (err) goto err_destroy_devices;
  }
  if (ledchain1_argc>0) {
    err = p44ledchain_add_device(p44ledchain_class, 1, &(p44ledchain_devices[1]), ledchain1, ledchain1_argc, "ledchain1");
    if (err) goto err_destroy_devices;
  }
  if (ledchain2_argc>0) {
    err = p44ledchain_add_device(p44ledchain_class, 2, &(p44ledchain_devices[2]), ledchain2, ledchain2_argc, "ledchain2");
    if (err) goto err_destroy_devices;
  }
  if (ledchain3_argc>0) {
    err = p44ledchain_add_device(p44ledchain_class, 3, &(p44ledchain_devices[3]), ledchain3, ledchain3_argc, "ledchain3");
    if (err) goto err_destroy_devices;
  }
  // done
  return 0;
err_destroy_devices:
  for (i=0; i<NUM_DEVICES; i++) {
    p44ledchain_remove_device(p44ledchain_class, i, &(p44ledchain_devices[i]));
  }
//err_free_irq:
  free_irq(pwm_irq_no, p44ledchain_devices);
err_unmap:
  iounmap(pwm_base);
//err_destroy_class:
  class_destroy(p44ledchain_class);
err_unregister_region:
  unregister_chrdev_region(MKDEV(p44ledchain_major, 0), NUM_DEVICES);
err:
  return err;
}



static void __exit p44ledchain_exit_module(void)
{
  int i;

  // destroy the devices
  for (i=0; i<NUM_DEVICES; i++) {
    p44ledchain_remove_device(p44ledchain_class, i, &(p44ledchain_devices[i]));
  }
  // free the IRQ
  free_irq(pwm_irq_no, p44ledchain_devices);
  // unmap PWM
  iounmap(pwm_base);
  // destroy the class
  class_destroy(p44ledchain_class);
  // unregister the region
  unregister_chrdev_region(MKDEV(p44ledchain_major, 0), NUM_DEVICES);
  // done
  printk(KERN_INFO LOGPREFIX "cleaned up\n");
	return;
}


module_init(p44ledchain_init_module);
module_exit(p44ledchain_exit_module);



