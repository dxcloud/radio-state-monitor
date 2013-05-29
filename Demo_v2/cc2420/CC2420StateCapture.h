/**
 * @file    cc2420/CC2420StateCapture.h
 * @author  Chengwu Huang
 * @date    2013-05-02
 * @version 1.1
 * @brief   List of available CC2420 radio states
 *
 * @details Power Supply
 *           _______________________________________________
 *          | Power Consumption | Min. | Typ. | Max. | Unit |
 *          |-------------------|------|------|------|------|
 *          | OFF               |      | 0.02 | 1    | uA   |
 *          |-------------------|------|------|------|------|
 *          | PD                |      | 20   |      | uA   |
 *          |-------------------|------|------|------|------|
 *          | IDLE              |      | 426  |      | uA   |
 *          |-------------------|------|------|------|------|
 *          | Rx                |      | 18.8 |      | mA   |
 *          |-------------------|------|------|------|------|
 *          | Tx:               |      |      |      |      |
 *          | P = -25 dBm       |      | 8.5  |      | mA   |
 *          | P = -15 dBm       |      | 9.9  |      | mA   |
 *          | P = -10 dBm       |      | 11   |      | mA   |
 *          | P = -5  dBm       |      | 14   |      | mA   |
 *          | P =  0  dBm       |      | 17.4 |      | mA   |
 *          \___________________|______|______|______|______|
 *
 *          see CC2420 datasheet section 5 'Operating Condition'
 */

#ifndef CC2420_STATE_CAPTURE_H
#define CC2420_STATE_CAPTURE_H

enum {
  STATE_OFF,      /** Voltage regulator off */
  STATE_PD,       /** Voltage regulator on */
  STATE_IDLE,     /** Including crytal oscillator and voltage regulator */
  STATE_RX,       /** Reception */
  STATE_TX        /** Transmission */
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

