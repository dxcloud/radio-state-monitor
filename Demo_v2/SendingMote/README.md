Demo_v2/SendingMote/README.md
================================================================================

**Date:** 2013-06-19    
**Author:** Chengwu Huang <chengwhuang@gmail.com>    
**Version:** 2.2

Directory contents
--------------------------------------------------------------------------------
* README.md (this file)
* Makefile
* SendingMoteC.nc
* SendingMoteP.nc

Description
--------------------------------------------------------------------------------
This SendingMote application is based on the first Demo and UDPEcho.
TinyOs 2.1.2 (or higher) is required. Same for the previous Demo application,
this one uses also CC2420 custom driver, therefore the flag
`CC2420_RADIO_STATE_CAPTURE` must be set in the Makefile.
Compile this application with blip stack (blip 2.0).

### Low Power Listening
Use the flag `LOW_POWER_LISTENING` to enable Low Power Listening. The sleep
interval can be modified by using `LPL_SLEEP_INTERVAL`.
`BLIP_L2_RETRIES` is the number of retries the radio will attempt.
The delay between two retries is defined by `BLIP_L2_DELAY`.

### Sensor
The SendingMote is able to activate several sensors.
To enable voltage sensor, set `VOLTAGE_SENSOR` in the Makefile.
In addition of voltage sensor, it is also possible to enable another sensor
between: temperature, humidity, visible light and all light. Only enable one of
these at a time, by setting the corresponding flag and comment the others.

* Voltage conversion: `V / 4096 * 3`
* Temperature conversion: `-39.60 + 0.01 * T`


