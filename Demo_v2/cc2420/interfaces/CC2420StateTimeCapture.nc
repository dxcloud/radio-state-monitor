/**
 * Interface provides capture event, used for the determination of the
 * current state of the radio.
 *
 * @author Chengwu Huang
 * @date   2013 - 05 - 02
 */

#include "CC2420.h"

interface CC2420StateTimeCapture {

  async event void timeCaptured(uint8_t val, uint32_t time);
}

