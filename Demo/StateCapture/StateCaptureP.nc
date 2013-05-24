/**
 * @file    Demo/StateCapture/StateCaptureP.nc
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-05-16
 * @version 1.1
 * @brief   
 */

#include "CC2420StateCapture.h"

module StateCaptureP {
  provides interface StateCapture;

  uses interface CC2420RadioStateCapture as PowerCapture;
  uses interface CC2420RadioStateCapture as TxCapture;
  uses interface CC2420RadioStateCapture as RxCapture;
  uses interface Counter<TMicro, uint32_t> as Counter;
}
implementation {
/******************************************************************************/
/* Global variables                                                           */
/******************************************************************************/
  uint8_t prev_state = 0;     /* Previous state */
  uint32_t prev_counter = 0;  /* Previous value of the counter */
  states_t report;            /* Temporary radio report */

/******************************************************************************/
/* Function Prototypes                                                        */
/******************************************************************************/
  void updateState(uint8_t new_state);

/******************************************************************************/
/* Command getReport                                                          */
/******************************************************************************/
  async command error_t StateCapture.getReport(states_t* states_report)
  {
    int i;
    atomic {
      updateState(prev_state);
      for (i = 0; i < NUM_STATES; ++i) {
        states_report->states[i] = report.states[i];
        report.states[i] = 0;
      }
    }
    return SUCCESS;
  }

/******************************************************************************/
/* Event PowerCapture (CC2420RadioStateCapture) captured                      */
/******************************************************************************/
  async event void PowerCapture.captured(uint8_t next_state)
  {
    updateState(next_state);
  }

/******************************************************************************/
/* Event RxCapture (CC2420RadioStateCapture) captured                         */
/******************************************************************************/
  async event void RxCapture.captured(uint8_t next_state)
  {
    updateState(next_state);
  }

/******************************************************************************/
/* Event TxCapture (CC2420RadioStateCapture) captured                         */
/******************************************************************************/
  async event void TxCapture.captured(uint8_t next_state)
  {
    updateState(next_state);
  }

/******************************************************************************/
/* Event Counter overflow detected                                            */
/******************************************************************************/
  async event void Counter.overflow()
  {
    call Counter.clearOverflow();
  }

/******************************************************************************/
/* Event PowerCapture (CC2420RadioStateCapture) captured                      */
/******************************************************************************/
  void updateState(uint8_t next_state)
  {
    atomic {
      uint32_t current_counter = call Counter.get();
      report.states[prev_state] += (current_counter - prev_counter);
      prev_counter = current_counter;
      prev_state = next_state;
    }
  }
}

