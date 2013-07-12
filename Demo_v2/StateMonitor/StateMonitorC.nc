
#include "blip_printf.h"

configuration StateMonitorC
{
}
implementation
{
  components MainC;
  components StateMonitorP as Monitor;
  Monitor.Boot -> MainC;

  components LedsC;
  Monitor.Leds -> LedsC;

  components UserButtonC;
  Monitor.Notify -> UserButtonC;

  components PrintfC, SerialStartC;
}

