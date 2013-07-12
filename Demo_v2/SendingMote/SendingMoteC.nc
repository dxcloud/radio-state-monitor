/**
 * @file    Demo_v2/SendingMote/SendingMoteC.nc
 * @date    2013-05-27
 * @auther  Chengwu Huang <chengwhuang@gmail.com>
 * @version 2.2
 * @details Changelog:
 *          - 2013-06-15: Random period reporting enabled
 *          - 2013-06-17: Sensing components added
 *          - 2013-06-20: Sending dummy packets enabled
 */

#include "report_message.h"
#include <lib6lowpan/ip.h>

#ifdef PRINTFUART_ENABLED
#include <blip_printf.h>
#endif

configuration SendingMoteC
{
}
implementation
{
  components MainC;
  components SendingMoteP as App;
  App.Boot -> MainC;

#if LED_ENABLED
  components LedsC;
  App.Leds -> LedsC;
#endif

  components new TimerMilliC() as ReportTimer;
  App.ReportTimer -> ReportTimer;

  components StateCaptureC;
  App.StateCapture -> StateCaptureC;

  components new UdpSocketC() as Report;
  App.Report -> Report;

  components IPStackC;
  App.RadioControl -> IPStackC;

#if DUMMY_SEND_ENABLED
  components new UdpSocketC() as Dummy;
  App.Dummy -> Dummy;

  components new TimerMilliC() as DummyTimer;
  App.DummyTimer -> DummyTimer;
#endif

#if RANDOM_ENABLED
  components RandomC;
  App.Random -> RandomC;
#endif

#ifdef RPL_ROUTING
  components RPLRoutingC;
#endif

#ifndef  IN6_PREFIX
  components DhcpCmdC;
#endif

#ifdef UDP_SHELL_ENABLED
  components UDPShellC;
  components RouteCmdC;
//  components ReportCmdC;
#endif

#if VOLTAGE_SENSOR
  components new DemoSensorC() as Voltage;
  App.Voltage -> Voltage;
#endif

#if TEMPERATURE_SENSOR || HUMIDITY_SENSOR
  components new SensirionSht11C() as Sensor;
#  if TEMPERATURE_SENSOR
  App.Temperature -> Sensor.Temperature;
#  endif
#  if HUMIDITY_SENSOR
  App.Humidity -> Sensor.Humidity;
#  endif
#endif

#if VISIBLE_LIGHT_SENSOR
  components new HamamatsuS1087ParC() as VisLightSensor;
  App.VisLight -> VisLightSensor;
#endif

#if ALL_LIGHT_SENSOR
  components new HamamatsuS10871TsrC() as AllLightSensor;
  App.AllLight -> AllLightSensor;
#endif

#ifdef PRINTFUART_ENABLED
//  components SerialPrintfC;
  components PrintfC, SerialStartC;
#endif

}

