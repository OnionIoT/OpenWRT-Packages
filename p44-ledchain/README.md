p44-ledchain for MT7688
=======================

This is a kernel module for the MT7688 SoC (as used in onion.io Omega2/Omega2S modules, but also in Linkit Smart 7688, VoCore2, HLK-7688 etc.) which makes use of the SoC's hardware PWM to drive individually addressable WS281x-type RGB and RGBW LED chains.

(c) 2017-2021 by luz@plan44.ch

## How does it work

The main goal was to produce the WS281x timing **without** ever blocking IRQs for longer periods of time.

Fortunately, the MT7688 has 4 PWM units (2 of them can be used on the Omega2) that can produce a sequence of 64 precisely (25ns resolution) timed low and high periods. Sadly, there's no DMA to produce longer sequences. So *p44-ledchain* uses the PWM interrupt to push the next 64 bits into the PWM. The interrupt response time is fast enough (~5 µS) in most cases to still meet the LED chain timing requirements but not in all cases. That's why the driver measures the interrupt response time and when it detects that it has failed to meet the timing, it will retry updating the chain from beginning. This prevents flickering at the possible cost of a reduced frame rate depending on system load.

At this time, *p44-ledchain* is extensively tested with WS2813 and WS2815 LED chains up to 1000 LEDs per output, using all 4 PWM channels in parallel, in several large projects. The driver also has modes for WS2811, WS2812 and the RGBW SK6812 LEDs.

Note that WS2812 and P9823 are most demanding regarding timing, so these are likely to need a lot of retries (and some need ever tighter timing than 10µS idle time between bits, see optional `maxTpassive` param [below](#maxtpassive)).

In general, WS2812 might not work really well with long chains or in environments where other factors put extra load on IRQs. WS2813 and WS2815 are much preferable because they can tolerate pauses between bits up to 35µS, which IRQ response almost always can meet. WS2813 are better than WS2812 anyway - the PWM is faster and failure of single LED does not break the chain. Same goes for WS2815 (bascially, a 12V version of WS2813B)

## Using p44-ledchain

after compiling/installing the p44-ledchain kernel module package, activate the driver as follows:

    insmod p44-ledchain ledchain<PWMno>=<inverted>,<numberofleds>,<ledtype>[,<maxretries>[,<maxTpassive>]]

Where

- **PWMno** The PWM to use. Can be 0..3 (Note: MT7688 PWM2/3 outputs are only exposed in the Omega2S, Omega2 only has PWM0 and 1).
- **inverted** can be 0 for non-inverted and 1 for inverted operation.
- **numberofleds** is the maximum number of LEDs in the chain. This number determines the size of the buffers allocated, but a too large LED count does not affect performance when using shorter chains. The maximum supported is 2048 LEDs. Note that the more LEDs you actually use, the longer the update will take, and the lower the maximum update rate will be. You can check the actual update time by reading the ledchain device, see [below](#minmaxupdatetime).
- **ledtype** selects the correct timing and byte order for different LED types. The ledtype can be composed from adding a chip type and a layout/byte order:

  Chip types:

  - **0x0001 = WS2811**: RGB LED driver (separate chip, rather ancient). Note: some WS2811 chips reportedly (thanks @Marti-MG!) do not work in this mode - but work fine in WS2813 mode.
  - **0x0002 = WS2812(B)**: RGB LEDs. Note that WS2812 have the most demanding timeout, as the maximum time between two bits may not exceed 10µS, and some chips might need less than 6µS. By default, WS2812 mode assumes 10µS, but if you see flickering in wrong colors then you need to tweak `maxTpassive` down and/or `maxrepeats` up, see [below](#maxtpassive).
  - **0x0003 = WS2813(B)**: 5V RGB LED with relaxed timing and single failed LED bridging. Generally, prefer WS2813 over WS2812 when possible ;-)
  - **0x0004 = WS2815**: 12V RGB LED with very simlar timing to WS2813.
  - **0x0005 = P9823**: RGB LED in standard 3mm and 5mm LED case, similar timing as WS2812.
  - **0x0006 = SK6812**: RGBW four channel LED, similar timing to WS2812.

  Layouts:

  - **0x0100 = RGB**: especially newer WS2815 have RGB byte order
  - **0x0200 = GRB**: most common order for WS281x
  - **0x0300 = RGBW**: some four channel LEDs
  - **0x0400 = GRBW**: usually SK6812 have this layout

  For full backwards compatibility with versions 5 and earlier of the *p44-lechain* driver, the following standard types are still supported:

  - **0 = WS2811 GRB**: same as 0x0201
  - **1 = WS2812(B) GRB**: same as 0x0202
  - **2 = WS2813(B)/WS2815 GRB**: same as 0x0203
  - **3 = P9823 RGB**: same as 0x0105
  - **4 = SK6812 GRBW**: same as 0x0406
  - **5 = WS2813/WS2815 RGB**: same as 0x0104

  Furthermore, the type can be set to *variable*:

  - **0x00FF = variable**: In this mode, the LED type is not fixed, but LED type parameters (chip type, channel layout, custom *maxTpassive*, custom *maxretries*) are sent as a header in every update. This allows higher level software to control the LED type without reloading the kernel driver. This is the mode to be used with p44utils' LedChainArrangements.

        The header consists of a lenght byte (must be >=5 in this version of the driver), followed by the **ledtype** (MSB first), followed by 2 bytes (MSB first) custom *maxTpassive* (0 for default), followed by 1 byte custom *maxretries* (0 for default).

- optional **maxretries** sets how many time an update is retried (when it could not complete due to IRQ response time not met). By default, this is 3.
- <a name="maxtpassive"></a>optional **maxTpassive** sets the maximum passive time allowed between bits in nanoseconds. By default, this is set to a known-good value for the LED type.
But especially in case of WS2812, some chips might need more tight timing. Note that the driver is unlikely to work for values below 5000nS and longer chains, because the average interrupt response time in an MT7688 is around 5000nS, so demanding less is likely to make no update get completed at all. For "difficult" WS2812 chips, I found that `maxretries=10` and `maxTPassive=5100` gives usable results. But try to set **maxTpassive** higher if possible. The default used in WS2812 mode is 10µS.

So, the following command will create a `/dev/ledchain0` device, which can drive 200 WS2813 LEDs connected without inverter to PWM0.

    insmod p44-ledchain ledchain0=0,200,2

or, using the newer flexible layout/chip specification (GRB layout + WS2813 chip):

    insmod p44-ledchain ledchain0=0,200,0x203

Of course, the pin multiplexer must be set such that PWM0 is actually output on the pin:

    omega2-ctrl gpiomux set pwm0 pwm

Now, with a WS2813 ledchain connected, you can update the LEDs by just writing a string of bytes into `/dev/ledchain0`:

    echo -en '\xFF\x00\x00\xFF\x00\x00' >/dev/ledchain0

This should make the first two LEDs bright red.

Another example: a "difficult" old WS2812 chain might be used on `/dev/ledchain1` with:

    insmod p44-ledchain ledchain1=0,200,1,10,5100

It will have a reduced frame rate, because it will probably need a lot of retries to meet the 5100nS maximum idle time between bits.

Another example: if you want to remain flexible in the type of LEDs without reloading the kernel module, insert it with *variable* led type:

    insmod p44-ledchain ledchain0=0,200,0xFF

Now each update sent to `/dev/ledchain0` must contain be prefixed with a 6 byte header, first byte being the header length, then two bytes for the led type (MSB first), then two bytes for *maxTpassive* value in uS (send 0 to use the chip's default *maxTpassive*) and one 1 byte custom *maxretries* (send 0 for default):

    #         |HEADER-----------------|LED DATA---------------|
    #         |len lay chp tpasv   rep| RR  GG  BB| RR  GG  BB|
    echo -en '\x05\x02\x03\x00\x00\x00\xFF\x00\x00\xFF\x00\x00' >/dev/ledchain0

## p44ledchaintest

There is a small utility `p44ledchaintest` (in the [same openwrt feed](https://github.com/plan44/plan44-feed) as p44-ledchain) which is intended to try and stress-test the p44-ledchain driver.

## Notes:

- Writing to the ledchain device will never block. Every write triggers an update of all LEDs starting with the first LED. In case the previous update is still in progress when the ledchain device is written again, it will be aborted and a new update cycle with the newly written data will be started.

- You should use a 3.3V to 5V level shifter between the Omega2/MT7688 PWM pin and the LED chain for reliable operation. Direct connection sometimes works, but the high level from the 3.3V output seems to be just on the minimum edge of what a 5V WS281x recognizes as high. Tiny differences in supply voltage for the LED chain can make it work or not.

- To check if the driver has completed applying the previous updates, and to see some statistics, the ledchain device can be read: `cat /dev/ledchain0`. The meanings of the values shown are:
    - The first line shows either "Ready" (when updating LEDs is complete) or "Busy" when an update is in progress.
    - **Last update:** on the second line shows:
        - **retries**: number of retries that were needed to complete the last update (write to /dev/ledchainX)
        - **last timeout**: the last IRQ response time that triggered a retry, because it was larger than the minimum chain reset time (defaults: 10'000nS for WS2812, 100'000nS for WS2813)
        - **min..max irq**: the lowest and highest IRQ response times measured during this update which did *not* trigger a retry. Helps to estimate the minimum possible setting of `maxTpassive`.
        - **duration**: time spent for the update.

    - **Totals:** on the third line shows:
        - **updates**: how many updates total (writes to /dev/ledchainX) have been requested.
        - **overruns**: how often updating the chain was stopped before it was completed, because the next update came too early. This does NOT cause flickering, but might cause LEDs further down the chain not receiving updates.
        - **retries**: how often the update had to be restarted, because the interrupt response was too slow and the update process had to be restarted before the whole chain was updated. That by itself should also NOT cause any flickering, but will only reduce the max possible frame rate because of the retries.
        - **errors**: how many times an update could not be applied after `maxretries` (default: 3) retries. In these cases, the driver gives up retrying, so the update of the LEDs will be incomplete (until a new update is started). If this happens a lot, you might want to increase `maxretries`.
        - **irqs**: just a counter of how many interrupt requests have been handled. One IRQ happens after every 64bits of PWM output, and one LED bit takes 2 or 3 PWM bits, so it's roughly one IRQ per updated LED.
        - <a name="minmaxupdatetime"></a>**min..max update duration**: min/max time spent for an update since the start of the driver. This gives an indication about the maximum frame rate (chain update rate) that might be possible - updating more often than `min update duration` will certainly not work, but an interval 1-2mS longer than `min update duration` usually will.

