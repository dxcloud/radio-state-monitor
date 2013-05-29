/**
 * @file    Demo/StateCapture/StateCapture.nc
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-05-16
 * @version 1.1
 * @brief   Provides interface to get a report about CC2420 radio activities
 */

#include "CC2420StateCapture.h"

interface StateCapture {
  /**
   * @brief Get a radio activities report
   * @param report Address of the array to be filled with the duration of each
   *               radio state.
   *               Note: states_t is a typedef type, the definition is in
   *               the file $(TOSDIR)/chips/cc2420/CC2420StateCapture.h
   */
  async command error_t getReport(states_t* report);
}

