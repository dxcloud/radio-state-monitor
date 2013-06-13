/**
 * @file    Demo/report_message.h
 * @author  Chengwu Huang
 * @date    2013-05-16
 * @version 1.1
 */

#ifndef REPORT_MESSAGE_H
#define REPORT_MESSAGE_H

#include "CC2420StateCapture.h"

enum {
  UDP_REPORT_PORT = 7060
};

/**
 * @struct report_message
 * @brief  Format of the packet
 *
 * ----------------------------------------------
 * | SN | ID |  OD  |  PD  |  LD  |  RD  |  TD  |
 * ----------------------------------------------
 *
 *     description                     - unit - size -
 * - SN: sequence number                   #   16 bits
 * - ID: identifier of the sending mote    #   16 bits
 * - OD: voltage regulator off duration   us   32 bits
 * - PD: power down duration              us   32 bits
 * - LD: idle duration                    us   32 bits
 * - RD: reception duration               us   32 bits
 * - TD: transmission duration            us   32 bits
 *
 * packet size: 182 bits <-> 24 bytes
 */
typedef nx_struct ReportMsg {
  nx_uint16_t seqno;
  nx_uint16_t sender;
  states_t    duration;  // see CC2420StateCapture.h
} ReportMsg;

#endif // REPORT_MESSAGE_H

