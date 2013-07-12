/**
 * @file    cc2420/CC2420StateCapture.h
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-05-02
 * @version 1.1
 * @brief   This file contains a list of available radio states for CC2420
 */

#ifndef CC2420_STATE_CAPTURE_H
#define CC2420_STATE_CAPTURE_H

enum {
  STATE_OFF = 0 ,  /** Voltage regulator off */
  STATE_PD,        /** Voltage regulator on */
  STATE_IDLE,      /** Including crytal oscillator and voltage regulator */
  STATE_RX,        /** Reception */
  STATE_TX         /** Transmission */
};

enum {
  NUM_STATES = 5  /** Number of states */
};

/**
 * @struct states
 * @brief  This is an array to contain the duration of each state
 */
typedef nx_struct states {
  nx_uint32_t states[NUM_STATES];  /** Array of NUM_STATES values */
} states_t;

#endif

