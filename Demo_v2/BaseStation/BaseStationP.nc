/**
 * @file BaseStationP.nc
 */

#include <report_message.h>

#ifndef APP_PORT
#define APP_PORT 7060
#endif

module BaseStationP
{
  uses {
    interface Boot;
    interface Leds;

    interface SplitControl as RadioControl;
    interface UDP as Report;

#if SERIAL_COMM_ENABLED
    interface SplitControl as SerialControl;
    interface AMSend as SerialSend;
    interface Packet as SerialPacket;
    interface AMPacket as SerialAMPacket;
#endif

  }
}

implementation
{
  void success_blink();
  void fail_blink();

  event void Boot.booted()
  {
    call RadioControl.start();
    call Report.bind(APP_PORT);  // listen port APP_PORT
#if SERIAL_COMM_ENABLED
    call SerialControl.start();
#endif
  }

  event void RadioControl.startDone(error_t err)
  {
    if (SUCCESS != err) {
      fail_blink();
      call RadioControl.start();
    }  // try again
  }

  event void RadioControl.stopDone(error_t err)
  {

  }

  /****************************************************************************/
  /* Report (UDP) received                                                    */
  /****************************************************************************/
  event void Report.recvfrom(struct sockaddr_in6 *from,
                             void *data,
                             uint16_t len,
                             struct ip6_metadata *meta)
  {

#if SERIAL_COMM_ENABLED
    if (sizeof(ReportMsg) == len) {
      message_t packet;
      ReportMsg* msg = (ReportMsg*)(call SerialPacket.getPayload(&packet,
                                                         sizeof(ReportMsg)));
      memcpy((void*) msg,(void* ) data, sizeof(ReportMsg));
      call SerialSend.send(AM_BROADCAST_ADDR, &packet, len);
    }
#endif
  }

#if SERIAL_COMM_ENABLED
  /****************************************************************************/
  /* Event SerialControl (SplitControl) started                               */
  /****************************************************************************/
  event void SerialControl.startDone(error_t err)
  {
    if (SUCCESS == err) {
      success_blink();
    }
    else {
      fail_blink();
      call SerialControl.start();
    }
  }

  /****************************************************************************/
  /* Event SerialControl (SplitControl) stopped                               */
  /****************************************************************************/
  event void SerialControl.stopDone(error_t err)
  {

  }

  /****************************************************************************/
  /* Event SerialSend (AMSend) message sent                                   */
  /****************************************************************************/
  event void SerialSend.sendDone(message_t* message, error_t err)
  {
    if (err == SUCCESS) {
      success_blink();
    }
    else {
      fail_blink();
    }
  }
#endif

  /* Toggle LED 1 to signal a successful event */
  void success_blink()
  {
#if LED_ENABLED
    call Leds.led1Toggle();
#endif
  }

  /* Toggle LED 2 to signal a failure */
  void fail_blink()
  {
#if LED_ENABLED
    call Leds.led2Toggle();
#endif
  }

}

