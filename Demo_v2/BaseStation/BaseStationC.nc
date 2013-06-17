/**
 * @file BaseStationC.nc
 */

#include <report_message.h>

configuration BaseStationC
{
}

implementation
{
  components MainC;
  components BaseStationP as App;
  App.Boot -> MainC;

  components LedsC;
  App.Leds -> LedsC;

  components IPStackC;
  App.RadioControl -> IPStackC;

  components new UdpSocketC() as Report;
  App.Report -> Report;

#ifdef RPL_ROUTING
  components RPLRoutingC;
#endif

#ifdef SERIAL_COMM_ENABLED
  components new SerialAMSenderC(AM_REPORTMSG) as SerialSender;
  App.SerialSend -> SerialSender;

  components SerialActiveMessageC as Serial;
  App.SerialControl -> Serial;
  App.SerialPacket -> Serial;
  App.SerialAMPacket -> Serial;
#endif

}

