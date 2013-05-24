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
  AM_REPORTMSG = 240,
  AM_DUMMYMSG = 100,
  AM_BASE_STATION_ADDR = 1,
  AM_DUMMY_ADDR = 0
};

/**
 * @struct report_message
 * @brief  Format of the packet
 *
 * ---------------------------------------------------
 * | ID | SN |  OD  |  PD  |  LD  |  RD  |  TD  | RS |
 * ---------------------------------------------------
 *
 * - description                     - unit - size -
 * ID: identifier of the sending mote    #   16 bits
 * SN: sequence number                   #   16 bits
 * OD: voltage regulator off duration   us   32 bits
 * PD: power down duration              us   32 bits
 * LD: idle duration                    us   32 bits
 * RD: reception duration               us   32 bits
 * TD: transmission duration            us   32 bits
 * RS: RSSI                            dBm    8 bits
 *
 * packet size: 200 bits <-> 25 bytes
 */
typedef nx_struct ReportMsg {
  nx_uint16_t node_id;
  nx_uint16_t seq_num;
  states_t duration;
  nx_int8_t rssi;
} ReportMsg;

#endif // REPORT_MESSAGE_H

