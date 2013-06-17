/**
 * @file    SendingMoteP.nc
 * @date    2013-06-17
 * @version 2.1
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @brief   
 */

#include "report_message.h"
#include <lib6lowpan/ip.h>

#ifndef REPORT_INTERVAL
#define REPORT_INTERVAL 1000  // Default report packet period
#endif

#ifndef APP_PORT
#define APP_PORT 7060
#endif

#if RANDOM_ENABLED
#  undef APP_PERIOD  // disable periodic report
#  ifndef RANDOM_MAX
#    define RANDOM_MAX 600000UL // Default max random value
#  endif
#  ifndef RANDOM_MIN
#    define RANDOM_MIN 60000UL  // Default min random value
#  endif
#endif

module SendingMoteP
{
  uses {
    interface Boot;
    interface Leds;
    interface Timer<TMilli> as ReportTimer;
    interface StateCapture;
    interface SplitControl as RadioControl;
    interface UDP as Report;

#if RANDOM_ENABLED
    interface Random;
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
  ReportMsg report;
  struct sockaddr_in6 dest;

  /****************************************************************************/
  /* Function prototype                                                       */
  /****************************************************************************/

  task void send_task();

  /** @brief Blink LED 2 for a failed action */
  inline void fail_blink();

  /** @brief Blink LED 1 for a successful action */
  inline void success_blink();

#if RANDOM_ENABLED
  /** @brief Get a random number between RANDOM_MIN and RANDOM_MAX */
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
    dest.sin6_port = htons(UDP_REPORT_PORT);
    report.sender = TOS_NODE_ID;
  }

  /* RadioControl.startDone (SplitControl) ************************************/
  event void RadioControl.startDone(error_t err)
  {
    if (SUCCESS == err) {
      success_blink();
#if RANDOM_ENABLED
      call ReportTimer.startOneShot(get_rand());
#else
      call ReportTimer.startPeriodic(REPORT_INTERVAL);
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

  }

#if VOLTAGE_SENSOR
  /* Voltage.readDone (Read) **************************************************/
  event void Voltage.readDone(error_t err, uint16_t data)
  {
    report.voltage = data;
  }
#endif

#if TEMPERATURE_SENSOR
  /* Temperature.readDone (Read) **********************************************/
  event void Temperature.readDone(error_t err, uint16_t data)
  {
    report.sensor = data;
  }
#endif

#if HUMIDITY_SENSOR
  /* Humidity.readDone (Read) *************************************************/
  event void Humidity.readDone(error_t err, uint16_t data)
  {
    report.sensor = data;
  }
#endif

#if VISIBLE_LIGHT_SENSOR
  event void VisLight.readDone(error_t err, uint16_t data)
  {
    report.sensor = data;
  }
#endif

#if ALL_LIGHT_SENSOR
  event void AllLight.readDone(error_t err, uint16_t data)
  {
    report.sensor = data;
  }
#endif

  /****************************************************************************/
  /* Function definition                                                      */
  /****************************************************************************/

  /* send_task ****************************************************************/
  task void send_task()
  {
    if (SUCCESS == call Report.sendto(&dest, &report, sizeof(report))) {
      success_blink();
    }
    else {
      fail_blink();
    }
#if RANDOM_ENABLED
    call ReportTimer.startOneShot(get_rand());
#endif
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
    return (call Random.rand32() % RANDOM_MAX) + RANDOM_MIN;
  }
#endif

}

