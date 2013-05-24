/**
 * @file    cc2420/Interface/CC2420RadioStateCapture.nc
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-05-02
 * @version 1.1
 * @brief   Interface provides captured radio state event.
 */

#include "CC2420.h"

interface CC2420RadioStateCapture {
  /**
   * @brief When a radio transition is enable, a captured event is triggered.
   *        The available transitions (such as STXON, SRXON...) are described
   *        in the datasheet.
   *        (see CC2420 datasheet section 20 'Radio control state machine')
   * @param next_state This parameter indicates the current state of the radio.
   *        (see file CC2420StateCapture.h for the list of radio state)
   */
  async event void captured(uint8_t next_state);

}
