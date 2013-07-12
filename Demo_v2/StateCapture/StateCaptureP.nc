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
  uint8_t prev_state = 0;     // Previous state
  uint32_t prev_counter = 0;  // Previous value of the counter
  states_t report;            // Local radio report

/******************************************************************************/
/* Function Prototypes                                                        */
/******************************************************************************/
  inline void updateState(uint8_t new_state);

/******************************************************************************/
/* Command getReport                                                          */
/******************************************************************************/
  async command error_t StateCapture.getReport(states_t* states_report)
  {
    atomic {
      updateState(prev_state);
      memcpy((uint8_t*) states_report, (uint8_t*) &report, sizeof(states_t));
      memset((void*) &report, 0, sizeof(states_t));
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
      uint32_t cur_counter = call Counter.get();
      report.states[prev_state] += (cur_counter - prev_counter);
      prev_state = next_state;
      prev_counter = cur_counter;
    }
  }
}

