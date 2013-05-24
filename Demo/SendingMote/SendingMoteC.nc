/**
 * @file    Demo/SendingMote/SendingMoteC.nc
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-05-16
 * @version 1.1
 * @brief   The sending mote sends its radio activities report
 */

#include "report_message.h"

#ifdef PRINTF_ENABLED
#include "printf.h"
#endif

configuration SendingMoteC
{
}
implementation
{
  components SendingMoteP as App;
  components MainC;
  App.Boot -> MainC;

  components LedsC;
  App.Leds -> LedsC;

  components StateCaptureC as Capture;
  App.StateCapture -> Capture;

  components new TimerMilliC() as ReportTimer;
  App.ReportTimer -> ReportTimer;

  components ActiveMessageC as Radio;
  App.RadioControl -> Radio;
  App.Packet -> Radio;
  App.AMPacket -> Radio;
#ifdef LOW_POWER_LISTENING
  App.Lpl -> Radio;
#endif

  components new AMSenderC(AM_REPORTMSG) as ReportSender;
  App.ReportSend -> ReportSender;

#ifdef ACKNOWLEDGEMENT_ENABLED
  App.Ack -> Radio;
  components new TimerMilliC() as AckTimer;
  App.AckTimer -> AckTimer;
#endif

#ifdef DUMMY_SEND_ENABLED
  components new TimerMilliC() as DummyTimer;
  App.DummyTimer -> DummyTimer;

  components new AMSenderC(AM_DUMMYMSG) as DummySender;
  App.DummySend -> DummySender;
#endif

#ifdef PRINTF_ENABLED
  components PrintfC;
  components SerialStartC;
#endif
}

