/**
 * @file    StateMonitor.h
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-07-19
 * @brief   Define structure format of printing values
 */

//#include "CC2420StateCapture.h"

/**
 * @struct StateMonitorPrint
 */
typedef struct StateMonitorPrint
{
  uint8_t  r_state;     //< Numerical value of the radio state
  uint32_t r_duration;  //< Timestamp
} state_print_t;

