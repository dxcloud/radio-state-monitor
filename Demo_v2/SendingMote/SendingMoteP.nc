#include "report_message.h"

module SendingMoteP
{
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as ReportTimer;
  uses interface StateCapture;
  uses interface SplitControl as RadioControl;
  uses interface UDP as Report;
}
implementation
{
  ReportMsg report;

/******************************************************************************/
/* Event Boot booted */
/******************************************************************************/
  event void Boot.booted()
  {
    call RadioControl.start();
  }

/******************************************************************************/
/******************************************************************************/
  event void RadioControl.startDone(error_t err)
  {

  }

/******************************************************************************/
/******************************************************************************/
  event void RadioControl.stopDone(error_t err)
  {

  }

/******************************************************************************/
/******************************************************************************/
  event void ReportTimer.fired()
  {

  }

/******************************************************************************/
/******************************************************************************/
  event void Report.recvfrom(struct sockaddr_in6 *from, void *data,
                             uint16_t len, struct ip6_metadata *meta)
  {

  }

}

