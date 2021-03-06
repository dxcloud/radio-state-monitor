/**
 * @file    SendingMoteP.nc
 * @date    2013-06-17
 * @version 2.1
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @brief   This application sends a UDP report periodically, it sends also
 *          (periodically or randomly) dummy packets to simulate a working node
 */

#include "report_message.h"
#include <lib6lowpan/ip.h>

#ifndef APP_PERIOD
#define APP_PERIOD 60000UL  // Default report packet period
#endif

#ifndef APP_PORT
#define APP_PORT 7060
#endif

#if DUMMY_SEND_ENABLED
#  if RANDOM_ENABLED
#    undef DUMMY_PERIOD  // disable periodic dummy sending
#    ifndef RANDOM_MAX
#    define RANDOM_MAX 600000UL // Default max random value
#    endif
#    ifndef RANDOM_MIN
#    define RANDOM_MIN 60000UL  // Default min random value
#    endif
#  else
#    ifndef DUMMY_PERIOD
#    define DUMMY_PERIOD 60000UL
#    endif
#  endif
#endif

#if (TEMPERATURE_SENSOR || HUMIDITY_SENSOR || VISIBLE_LIGHT_SENSOR || ALL_LIGHT_SENSOR)
#define SENSOR_ENABLED
#endif

module SendingMoteP
{
  uses {
    interface Boot;
#if LED_ENABLED
    interface Leds;
#endif
    interface Timer<TMilli> as ReportTimer;
    interface StateCapture;
    interface SplitControl as RadioControl;
    interface UDP as Report;

#if DUMMY_SEND_ENABLED
    interface UDP as Dummy;
    interface Timer<TMilli> as DummyTimer;

#  if RANDOM_ENABLED
    interface Random;
#  endif
#endif


#if VOLTAGE_SENSOR
    interface Read<uint16_t> as Voltage;
#endif

#if TEMPERATURE_SENSOR
    interface Read<uint16_t> as Temperature;
#endif

#if HUMIDITY_SENSOR
    interface Read<uint16_t> as Humidity;
#endif

#if VISIBLE_LIGHT_SENSOR
    interface Read<uint16_t> as VisLight;
#endif

#if ALL_LIGHT_SENSOR
    interface Read<uint16_t> as AllLight;
#endif
  }
}
implementation
{
  ReportMsg report;  // report packet format
  struct sockaddr_in6 dest;

#if DUMMY_SEND_ENABLED
  ReportMsg dummy_packet;  // empty dummy packet
  struct sockaddr_in6 dummy_dest;
#endif

#if VOLTAGE_SENSOR
  bool voltage_read = FALSE;  // TRUE if 'Voltage.readDone' triggered
#endif

#ifdef SENSOR_ENABLED
  bool sensor_read = FALSE;
#endif

  /****************************************************************************/
  /* Function prototype                                                       */
  /****************************************************************************/

  /* Task for sending report packets */
  task void send_task();

  /* Blink LED 2 for a failed action */
  inline void fail_blink();

  /* Blink LED 1 for a successful action */
  inline void success_blink();

#if RANDOM_ENABLED
  /* Get a random number between RANDOM_MIN and RANDOM_MAX */
  inline uint32_t get_rand();
#endif

  /****************************************************************************/
  /* Event                                                                    */
  /****************************************************************************/

  /* Boot.booted **************************************************************/
  event void Boot.booted()
  {
    call RadioControl.start();
    inet_pton6(REPORT_DEST, &dest.sin6_addr);
    dest.sin6_port = htons(APP_PORT);  // destination port
    report.sender = TOS_NODE_ID;
#if DUMMY_SEND_ENABLED
    inet_pton6(DUMMY_DEST, &dummy_dest.sin6_addr);
#endif
  }

  /* RadioControl.startDone (SplitControl) ************************************/
  event void RadioControl.startDone(error_t err)
  {
    if (SUCCESS == err) {
      success_blink();
      call ReportTimer.startPeriodic(APP_PERIOD);

#if DUMMY_SEND_ENABLED
#  if RANDOM_ENABLED
      call DummyTimer.startOneShot(get_rand());
#  else  // random dummy packets sending
      call DummyTimer.startPeriodic(DUMMY_PERIOD);
#  endif  // periodic dummy packets sending
#endif
    }
    else {
      call RadioControl.start();
    }
  }

  /* RadioControl.stopDone (SplitControl) *************************************/
  event void RadioControl.stopDone(error_t err)
  {

  }

  /* ReportTimer.fired (Timer) ************************************************/
  event void ReportTimer.fired()
  {
    ++report.seqno;
    call StateCapture.getReport(&report.duration);

#if VOLTAGE_SENSOR
    call Voltage.read();
#endif

#if TEMPERATURE_SENSOR
    call Temperature.read();
#endif

#if HUMIDITY_SENSOR
    call Humidity.read();
#endif

#if VISIBLE_LIGHT_SENSOR
    call VisLight.read();
#endif

#if ALL_LIGHT_SENSOR
    call AllLight.read();
#endif

    post send_task();
  }

  /* Report.recvfrom (UDP) ****************************************************/
  event void Report.recvfrom(struct sockaddr_in6 *from,
                             void *data,
                             uint16_t len,
                             struct ip6_metadata *meta)
  {
    // nothing to do
  }

#if DUMMY_SEND_ENABLED
  /* DummyTimer.fired (Timer) *************************************************/
  event void DummyTimer.fired() {
    call Dummy.sendto(&dummy_dest, &dummy_packet, sizeof(dummy_packet));
#if RANDOM_ENABLED
    call DummyTimer.startOneShot(get_rand());
#endif
  }

  /* Dummy.recvfrom (UDP) *****************************************************/
  event void Dummy.recvfrom(struct sockaddr_in6 *from,
                             void *data,
                             uint16_t len,
                             struct ip6_metadata *meta)
  {
  }
#endif

#if VOLTAGE_SENSOR
  /* Voltage.readDone (Read) **************************************************/
  event void Voltage.readDone(error_t err, uint16_t data)
  {
    report.voltage = data;
    voltage_read = TRUE;
  }
#endif

#if TEMPERATURE_SENSOR
  /* Temperature.readDone (Read) **********************************************/
  event void Temperature.readDone(error_t err, uint16_t data)
  {
    report.sensor = data;
    sensor_read = TRUE;
  }
#endif

#if HUMIDITY_SENSOR
  /* Humidity.readDone (Read) *************************************************/
  event void Humidity.readDone(error_t err, uint16_t data)
  {
    report.sensor = data;
    sensor_read = TRUE;
  }
#endif

#if VISIBLE_LIGHT_SENSOR
  /* VisLight.readDone ********************************************************/
  event void VisLight.readDone(error_t err, uint16_t data)
  {
    report.sensor = data;
    sensor_read = TRUE;
  }
#endif

#if ALL_LIGHT_SENSOR
  /* AllLight.readDone ********************************************************/
  event void AllLight.readDone(error_t err, uint16_t data)
  {
    report.sensor = data;
    sensor_read = TRUE;
  }
#endif

  /****************************************************************************/
  /* Function definition                                                      */
  /****************************************************************************/

  /* send_task ****************************************************************/
  task void send_task()
  {
#if VOLTAGE_SENSOR
    if (FALSE == voltage_read) {
      post send_task();
      return;
    }
#endif

#ifdef SENSOR_ENABLED
    if (FALSE == sensor_read) {
      post send_task();
      return;
    }
#endif

    if (SUCCESS == call Report.sendto(&dest, &report, sizeof(report))) {
      success_blink();

#if VOLTAGE_SENSOR
      voltage_read = FALSE;
#endif

#ifdef SENSOR_ENABLED
      sensor_read = FALSE;
#endif

    }
    else {
      fail_blink();
    }
  }

  /* succes_blink *************************************************************/
  void success_blink()
  {
#if LED_ENABLED
    call Leds.led1Toggle();
#endif
  }

  /* fail_blink ***************************************************************/
  void fail_blink()
  {
#if LED_ENABLED
    call Leds.led2Toggle();
#endif
  }

#if RANDOM_ENABLED
  /* get_rand *****************************************************************/
  uint32_t get_rand()
  {
    return (call Random.rand32() % (RANDOM_MAX - RANDOM_MIN)) + RANDOM_MIN;
  }
#endif
}

