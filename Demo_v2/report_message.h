/**
 * @file    Demo/report_message.h
 * @author  Chengwu Huang
 * @date    2013-05-16
 * @version 1.2
 * @brief   Define the report packet format
 * @details Changelog:
 *          - 2013-06-17: fields `voltage' and `sensor' added
 */

#ifndef REPORT_MESSAGE_H
#define REPORT_MESSAGE_H

#include "CC2420StateCapture.h"

enum {
  AM_REPORTMSG    = 240  // Active Message ID for PC-mote communication
};

/**
 * @struct report_message
 * @brief  Format of the packet
 *
 *         packet size: 224 bits <-> 28 bytes
 */
typedef nx_struct ReportMsg {
  nx_uint16_t  seqno;     /** Sequence number */
  nx_uint16_t  sender;    /** Sender Identifier */
  states_t     duration;  /** @see CC2420StateCapture.h */
  nx_uint16_t  voltage;   /** Battery voltage */
  nx_uint16_t  sensor;    /** Other sensor (e.g. temperature) */
} ReportMsg;

#endif // REPORT_MESSAGE_H

