/**
 * @file    Demo/report_message.h
 * @author  Chengwu Huang
 * @date    2013-05-16
 * @version 1.1
 */

#ifndef REPORT_MSG_H
#define REPORT_MSG_H

enum {
  NUM_STATES = 5,
  AM_REPORTMSG = 240
};

typedef nx_struct ReportMsg {
  nx_uint16_t node_id;
  nx_uint16_t seq_num;
  nx_uint32_t duration[NUM_STATES];
  nx_int8_t rssi;
} ReportMsg;



#endif // REPORT_MSG_H

