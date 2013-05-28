/**
 * @file    Demo/BaseStation/BaseStationC.nc
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-05-16
 * @version 1.1
 * @brief   The BaseStation is able to receive packets from SendingMote
 */

#include "report_message.h"

#ifdef PRINTF_ENABLED
#include "printf.h"
#endif

configuration BaseStationC
{
}
implementation
{
  components BaseStationP as App;
  components MainC;
  App.Boot -> MainC;

  components ActiveMessageC as Radio;
  App.RadioControl -> Radio;
  App.RadioPacket -> Radio;
  App.RadioAMPacket -> Radio;
  App.RadioReceive -> Radio.Receive[AM_REPORTMSG];

  components LedsC;
  App.Leds -> LedsC;

  components CC2420ActiveMessageC;
  App.RssiPacket -> CC2420ActiveMessageC;

#ifdef SERIAL_COMM_ENABLED
  components new SerialAMSenderC(AM_REPORTMSG) as SerialSender;
  App.SerialSend -> SerialSender;

  components SerialActiveMessageC as Serial;
  App.SerialControl -> Serial;
  App.SerialPacket -> Serial;
  App.SerialAMPacket -> Serial;
#endif

#ifdef PRINTF_ENABLED
  components PrintfC;
  components SerialStartC;
#endif
}

