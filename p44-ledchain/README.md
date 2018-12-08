p44-ledchain for MT7688
=======================

This is a kernel module for the MT7688 SoC (as used in onion.io Omega2/Omega2S modules, but also in Linkit Smart 7688, VoCore2, HLK-7688 etc.) which makes use of the SoC's hardware PWM to drive individually addressable WS281x-type RGB and RGBW LED chains.

(c) 2017-2018 by luz@plan44.ch

## How does it work

The main goal was to produce the WS281x timing **without** ever blocking IRQs for longer periods of time.

Fortunately, the MT7688 has 4 PWM units (2 of them can be used on the Omega2) that can produce a sequence of 64 precisely (25ns resolution) timed low and high periods. Sadly, there's no DMA to produce longer sequences. So *p44-ledchain* uses the PWM interrupt to push the next 64 bits into the PWM. The interrupt response time is fast enough (~5 µS) in most cases to still meet the LED chain timing requirements (not more than 10uS idle time between bits for WS2812) - but not in all cases. That's why the driver measures the interrupt response time and when it detects that it has failed to meet the timing, it will retry updating the chain from beginning. This prevents flickering at the possible cost of a reduced frame rate depending on system load.

At this time, *p44-ledchain* is extensively tested with WS2813 LED chains up to 518 LEDs in a large project. The driver also has modes for WS2811, WS2812 and the RGBW SK6812 LEDs.

Note that WS2812 and P9823 are most demanding regarding timing, so these are more likely to need retries than WS2813 which allows up to 100µS idle time between bits. In general, WS2813 are better than WS2812 anyway - faster PWM, better timing and failure of single LED does not break chain.


## Using p44-ledchain

after compiling/installing the p44-ledchain kernel module package, activate the driver as follows:

    insmod p44-ledchain ledchain<PWMno>=<inverted>,<numberofleds>,<ledtype>

Where

- *PWMno* The PWM to use. Can be 0..3 (Note: MT7688 PWM2/3 outputs are only exposed in the Omega2S, Omega2 only has PWM0 and 1).
- *inverted* can be 0 for non-inverted and 1 for inverted operation.
- *numberofleds* is the maximum number of LEDs in the chain. This number determines the size of the buffers allocated, but a too large LED count does not affect performance when using shorter chains.
- *ledtype* selects the correct timing and byte order for different LED types:
  - 0 : **WS2811** RGB LED driver (separate chip, rather ancient). Note: some WS2811 chips reportedly (thanks @Marti-MG!) do not work in this mode - but work fine in WS2813 mode.
  - 1 : **WS2812** and **WS2812B** RGB LEDs
  - 2 : **WS2813** RGB LED with relaxed timing and single failed LED bridging
  - 3 : **P9823** RGB LED in standard 3mm and 5mm LED case, similar timing as WS2812 but different byte order (RGB rather than GRB)
  - 4 : **SK6812** RGBW four channel LED, similar timing to WS2812

So, the following command will create a `/dev/ledchain0` device, which can drive 200 WS2813 LEDs connected without inverter to PWM0.

    insmod p44-ledchain ledchain0=0,200,2

Of course, the pin multiplexer must be set such that PWM0 is actually output on the pin:

    omega2-ctrl gpiomux set pwm0 pwm

Now, with a WS2813 ledchain connected, you can update the LEDs by just writing a string of bytes into /dev/ledchain0:

    echo -en '\xFF\x00\x00\xFF\x00\x00' >/dev/ledchain0

This should make the first two LEDs bright red.

## Notes:

- Writing to the ledchain device will never block. Every write triggers an update of all LEDs starting with the first LED. In case the previous update is still in progress when the ledchain device is written again, it will be aborted and a new update cycle with the newly written data will be started.

- To check if the driver has completed applying the previous updates, and to see some statistics, the ledchain device can be read: `cat /dev/ledchain0`

- You should use a 3.3V to 5V level shifter between the Omgea2/MT7688 PWM pin and the LED chain for reliable operation. Direct connection sometimes works, but the high level from the 3.3V output seems to be just on the minimum edge of what a 5V WS281x recognizes as high. Tiny differences in supply voltage for the LED chain can make it work or not.
