/**
 * @file Demo_v2/SendingMote/SendingMoteC.nc
 * @date 2013-05-27
 */

#include "report_message.h"

configuration SendingMoteC
{
}
implementation
{
  components MainC;
  components SendingMoteP as App;
  App.Boot -> MainC;

  components LedsC;
  App.Leds -> LedsC;

  components new TimerMilliC() as ReportTimer;
  App.ReportTimer -> ReportTimer;

  components StateCaptureC;
  App.StateCapture -> StateCaptureC;

  components new UdpSocketC() as Report;
  App.Report -> Report;

  components IPStackC;
  App.RadioControl -> IPStackC;
}

