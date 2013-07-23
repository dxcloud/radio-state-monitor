/**
 * @file    StateMonitorP.nc
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-07-19
 * @brief   Active the debugging mode by pressing `User button'.
 * @details This component uses ring buffer for w/r, the size is defined
 *          by the constant `RING_BUFFER_SIZE'. If the size is too short,
 *          it may not able to print all states.
 */

#include "UserButton.h"
#include "Timer.h"
#include "StateMonitor.h"

#ifdef PRINTFUART_ENABLED
#include "blip_printf.h"
#else
#include "printf.h"
#endif

#define NOTIFY_DELAY 1000  // LED duration for notification

#ifndef RING_BUFFER_SIZE
#define RING_BUFFER_SIZE 56
#endif

module StateMonitorP
{
  provides interface Init;

  uses interface Leds;
  uses interface Notify<button_state_t>;
  uses interface Timer<TMilli>;

  uses interface CC2420RadioStateCapture as PowerCapture;
  uses interface CC2420RadioStateCapture as TxCapture;
  uses interface CC2420RadioStateCapture as RxCapture;

#if defined(COUNTER_MICRO_ENABLED)
    uses interface Counter<TMicro, uint32_t> as Counter;
#elif defined(COUNTER_32KHZ_ENABLED)
   uses interface Counter<T32khz, uint32_t> as Counter;
#else
   uses interface Counter<TMilli, uint32_t> as Counter;
#endif
}
implementation
{
  /****************************************************************************/
  /* Variables                                                                */
  /****************************************************************************/
  state_print_t monitor_buff[RING_BUFFER_SIZE]; // ring buffer
  norace bool active = FALSE;                   // TRUE: debugging mode enabled
  uint8_t read       = 0;                       // reading index
  uint8_t write      = 0;                       // writting index
  norace uint32_t start_counter;                // starting timestamp

  /****************************************************************************/
  /* Functions and Tasks                                                      */
  /****************************************************************************/  
  /**
   * @brief   Printing task, this task will run till debugging mode is on.
   * @details While the buffer is not empty, the value pointed by `read' index
   *          is printed.
   */
  task void print_task()
  {
    uint32_t timestamp;
    uint8_t state;

    if (FALSE == active) { return; }  // debugging mode deactivated
    atomic {
      if (read == write) {
        post print_task();
        return;
      }  // empty buffer
    }

    atomic {
      timestamp = monitor_buff[read].r_duration;
      state = monitor_buff[read].r_state;
      read = (read + 1) % RING_BUFFER_SIZE;
    }  // read values for printing
    printfflush();
    printf("%lu %u\n", timestamp, state);
    post print_task();
  }

  /**
   * @brief   Write data to the buffer. 
   * @details This function does not care whether the buffer is full,
   *          in that case the old values will be overwritten.
   */
  inline void rb_write(uint8_t val)
  {
    if (FALSE == active) { return; }
    atomic {
      monitor_buff[write].r_state = val;
      monitor_buff[write].r_duration = call Counter.get() - start_counter;
      write = (write + 1) % RING_BUFFER_SIZE;
    }  // write timestamp and radio state
  }

  /****************************************************************************/
  /* Initialize by enbling notifications from the User button.                */
  /****************************************************************************/
  command error_t Init.init()
  {
    return call Notify.enable();  // User button enabled
  }

  /****************************************************************************/
  /* Activate/Deactivate debugging mode by pressing User button.              */
  /* A LED turns on to testify the debugging mode is ON/OFF                   */
  /****************************************************************************/
  event void Notify.notify(button_state_t val)
  {
    if (BUTTON_PRESSED == val) {
      if (FALSE == active) {
        call Leds.led0On();
#ifdef DEBUG_NOTIFICATION
        printf("Debugging mode activated\n");
        printfflush();
#endif
        start_counter = call Counter.get();  // get current timestamp
        active = TRUE;
        post print_task();  // start displaying
      }  // debbuging mode activated
      else {
        active = FALSE;
        call Leds.led2On();
#ifdef DEBUG_NOTIFICATION
        printf("Debugging mode deactivated\n");
        printfflush();
#endif
      }  // deactivated
    }  // button pressed
    call Timer.startOneShot(NOTIFY_DELAY);  // turn off LEDs
  }

  /****************************************************************************/
  /* Turn off LED after a delay (defined by `NOTIFY_DELAY').                  */
  /****************************************************************************/
  event void Timer.fired()
  {
    call Leds.led0Off();
    call Leds.led2Off();
  }

  /****************************************************************************/
  /* PowerCapture, TxCapture, RxCapture are triggered when radio events are   */
  /* detected. Call function `rb_write'                                       */
  /****************************************************************************/
  async event void PowerCapture.captured(uint8_t next_state)
  {
//    if (0 == next_state) { call Leds.led1Toggle(); }
    rb_write(next_state);
  }

  /****************************************************************************/
  async event void TxCapture.captured(uint8_t next_state)
  {
    rb_write(next_state);
  }

  /****************************************************************************/
  async event void RxCapture.captured(uint8_t next_state)
  {
    rb_write(next_state);
  }

  /****************************************************************************/
  /* Clear overflow when detected.                                            */
  /****************************************************************************/
  async event void Counter.overflow()
  {
    call Counter.clearOverflow();
  }
}

