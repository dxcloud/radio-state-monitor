/**
 * @file    Demo/BaseStation/BaseStationP.nc
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-05-16
 * @version 1.1
 * @brief   To show the report set SERIAL_COMM_ENABLED (or PRINTF_ENABLED) 
 *          in the Makefile.
 *          Prefer SERIAL_COMM_ENABLED to PRINTF_ENABLED.
 *          A java application can be used to show different values in the
 *          received packet (see directory Demo/java).
 *          Instead if PRINTF_ENABLED is set, use net.tinyos.tools.PrintfClient
 */

#include "Timer.h"

#include "report_message.h"

#ifdef PRINTF_ENABLED
#include "printf.h"
#endif

//#ifdef SERIAL_COMM_ENABLED
//#undef PRINTF_ENABLED
//#endif

module BaseStationP
{
  uses interface Boot;
  uses interface Leds;

  uses interface SplitControl as RadioControl;
  uses interface Receive as RadioReceive;
  uses interface Packet as RadioPacket;
  uses interface AMPacket as RadioAMPacket;

  uses interface CC2420Packet as RssiPacket;

#ifdef SERIAL_COMM_ENABLED
  uses interface SplitControl as SerialControl;
  uses interface AMSend as SerialSend;
  uses interface Packet as SerialPacket;
  uses interface AMPacket as SerialAMPacket;
#endif

#ifdef TIMESTAMP_ENABLED
  uses interface PacketTimeStamp<TMilli, uint32_t>;
#endif
}
implementation
{
/******************************************************************************/
/* Function Prototypes                                                        */
/******************************************************************************/
  void fail_blink();

  void success_blink();

/******************************************************************************/
/* Event Boot booted                                                          */
/******************************************************************************/
  event void Boot.booted()
  {
    call Leds.led0On();
    call RadioControl.start();
    call SerialControl.start();
  }

/******************************************************************************/
/* Event RadioControl (SplitControl) started                                  */
/******************************************************************************/
  event void RadioControl.startDone(error_t err)
  {
    if (SUCCESS == err) {
      success_blink();
    }
    else {
      fail_blink();
      call RadioControl.start();
    }
  }

/******************************************************************************/
/* Event RadioControl (SplitControl) stopped                                  */
/******************************************************************************/
  event void RadioControl.stopDone(error_t err)
  {
    // do nothing
  }

/******************************************************************************/
/* Event RadioReceive (Receive) message received                              */
/******************************************************************************/
  event message_t* RadioReceive.receive(message_t* msg,
                                        void* payload,
                                        uint8_t len)
  {
    if (sizeof(ReportMsg) == len) {
      ReportMsg* report;
      report = (ReportMsg*) payload;
      report->rssi = call RssiPacket.getRssi(msg);

#ifdef PRINTF_ENABLED
      printf("Receive Report:\n"
             "mote:%4i\n"
             "seq: %4i\n"
             "duration: [us]\n"
             " - OFF  %ld\n"
             " - PD   %ld\n"
             " - IDLE %ld\n"
             " - RX   %ld\n"
             " - TX   %ld\n"
             "rssi:%4i\n"
             "-----\n",
             report->node_id,
             report->seq_num,
             report->duration.states[STATE_OFF],
             report->duration.states[STATE_PD],
             report->duration.states[STATE_IDLE],
             report->duration.states[STATE_RX],
             report->duration.states[STATE_TX],
             report->rssi);
      printfflush();
#endif

#ifdef SERIAL_COMM_ENABLED
      call SerialSend.send(AM_BROADCAST_ADDR, msg, len);
#endif
    }
    return msg;
  }

#ifdef SERIAL_COMM_ENABLED
/******************************************************************************/
/* Event SerialControl (SplitControl) started                                  */
/******************************************************************************/
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

/******************************************************************************/
/* Event SerialControl (SplitControl) stopped                                 */
/******************************************************************************/
  event void SerialControl.stopDone(error_t err)
  {
    // do nothing
  }

/******************************************************************************/
/* Event SerialSend (AMSend) message sent                                     */
/******************************************************************************/
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
    call Leds.led1Toggle();
  }

  /* Toggle LED 2 to signal a failure */
  void fail_blink()
  {
    call Leds.led2Toggle();
  }
}

