/**
 * @file    Demo/SendingMote/SendingMoteP.nc
 * @author  Chengwu Huang
 * @date    2013-05-16
 * @version 1.3
 * @brief   The node sends a report to the BaseStation
 *          The flags `LOW_POWER_LISTENING', `DUMMY_SEND_ENABLED' and
 *          `ACKNOWLEDGMENT_ENABLED' will change its radio activities.
 * @details Adds
 *          - LPL
 *          - Sending dummy packet
 *          - Acknowledgement
 *          - Random
 */

#include "report_message.h"

#ifdef PRINTF_ENABLED
#include "printf.h"
#endif

#ifndef LPL_WAKEUP_INTERVAL
#define LPL_WAKEUP_INTERVAL 1000U
#endif

#ifndef REPORT_PERIOD
#define REPORT_PERIOD 60000U
#endif

#ifndef DUMMY_PERIOD
#define DUMMY_PERIOD 1000U
#endif

#ifndef ACK_DELAY
#define ACK_DELAY 1000
#endif

#ifndef MAX_ATTEMPT_SEND
#define MAX_ATTEMPT_SEND 3
#endif

module SendingMoteP
{
  uses interface Boot;
  uses interface Leds;
  uses interface StateCapture;

  uses interface Timer<TMilli> as ReportTimer;
  uses interface SplitControl as RadioControl;
  uses interface AMSend as ReportSend;
  uses interface Packet;
  uses interface AMPacket;

#ifdef LOW_POWER_LISTENING
  uses interface LowPowerListening as Lpl;
#endif

#ifdef DUMMY_SEND_ENABLED
  uses interface Timer<TMilli> as DummyTimer;
  uses interface AMSend as DummySend;
#  ifdef RANDOM_ENABLED
  uses interface Random;
#  endif
#endif

#ifdef ACKNOWLEDGEMENT_ENABLED
  uses interface PacketAcknowledgements as Ack;
  uses interface Timer<TMilli> as AckTimer;
#endif

}

implementation
{
  message_t packet;
  states_t report;
  int seqno = 0;
  bool busy = FALSE;

#ifdef ACKNOWLEDGEMENT_ENABLED
  uint8_t num_attempt_send = 0;
#endif

#ifdef DUMMY_SEND_ENABLED
  message_t dummy_packet;
#endif

/******************************************************************************/
/* Task and Function Prototypes                                               */
/******************************************************************************/
  task void send_task();

  void success_blink();

  void fail_blink();

#ifdef RANDOM_ENABLED
  uint32_t get_rand() {
    return (call Random.rand32() & REPORT_PERIOD);
  }
#endif

/******************************************************************************/
/* Event (Boot) booted                                                        */
/******************************************************************************/
  event void Boot.booted()
  {
    call RadioControl.start();
    call Leds.led0On();
  }

/******************************************************************************/
/* Event RadioControl (SplitControl) started                                  */
/******************************************************************************/
  event void RadioControl.startDone(error_t err)
  {
    if (SUCCESS == err) {
      call ReportTimer.startPeriodic(REPORT_PERIOD);

#ifdef LOW_POWER_LISTENING
      call Lpl.setLocalWakeupInterval(LPL_WAKEUP_INTERVAL);
#endif

#ifdef DUMMY_SEND_ENABLED
#  ifdef RANDOM_ENABLED
      call DummyTimer.startOneShot(get_rand());
#  else
      call DummyTimer.startPeriodic(DUMMY_PERIOD);
#  endif
#endif
    }
    else {
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
/* Event ReportTimer (Timer) fired                                            */
/******************************************************************************/
  event void ReportTimer.fired()
  {
    post send_task();
  }

/******************************************************************************/
/* Event ReportSend (AMSend) sent                                             */
/******************************************************************************/
  event void ReportSend.sendDone(message_t* message, error_t err)
  {
#ifdef ACKNOWLEDGEMENT_ENABLED
    if (TRUE == call Ack.wasAcked(message)) {
      success_blink();
      num_attempt_send = 0;
    }  // the packet is acknowledged
    else {
      fail_blink();
      if (MAX_ATTEMPT_SEND >= ++num_attempt_send) {
        call AckTimer.startOneShot(ACK_DELAY);
      }  // re-send the packet
      else {
        num_attempt_send = 0;
      }  // drop the packet
    }
#else
    if (SUCCESS == err) {
      success_blink();
    }
    else {
      fail_blink();
    }
#endif
    busy = FALSE;
  }

#ifdef ACKNOWLEDGEMENT_ENABLED
/******************************************************************************/
/* Event AckTimer (Timer) fired                                               */
/******************************************************************************/
  event void AckTimer.fired()
  {
    if (FALSE == busy) {
      busy = TRUE;
      call ReportSend.send(AM_BASE_STATION_ADDR, &packet, sizeof(ReportMsg));
    }
  }
#endif

#ifdef DUMMY_SEND_ENABLED
/******************************************************************************/
/* Event DummyTimer (Timer) fired                                             */
/******************************************************************************/
  event void DummyTimer.fired()
  {
    if (FALSE == busy) {
      busy = TRUE;
      call DummySend.send(AM_DUMMY_ADDR, &dummy_packet, 0);
    }
#  ifdef RANDOM_ENABLED
    call DummyTimer.startOneShot(get_rand());
#  endif
  }

/******************************************************************************/
/* Event DummySend (AMSend) sent                                              */
/******************************************************************************/
  event void DummySend.sendDone(message_t* message, error_t err)
  {
    busy = FALSE;
  }
#endif

/******************************************************************************/
/* Task and Function Definitions                                              */
/******************************************************************************/
  task void send_task()
  {
    if (FALSE == busy) {
      ReportMsg* msg = (ReportMsg*)(call Packet.getPayload(&packet,
                                                           sizeof(ReportMsg)));
      msg->node_id = TOS_NODE_ID;
      msg->seq_num = (++seqno);
      call StateCapture.getReport(&report);
      msg->duration = report;

#ifdef ACKNOWLEDGEMENT_ENABLED
      call Ack.requestAck(&packet);
#endif

      busy = TRUE;
      call ReportSend.send(AM_BASE_STATION_ADDR, &packet, sizeof(ReportMsg));
    }
    else {
      post send_task();
    }
  }

  void success_blink()
  {
    call Leds.led1Toggle();
  }

  void fail_blink()
  {
    call Leds.led2Toggle();
  }
}

