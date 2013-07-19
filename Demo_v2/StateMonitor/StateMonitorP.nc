#include "UserButton.h"
#include "Timer.h"
#include "StateMonitor.h"
#include "blip_printf.h"

#define NOTIFY_DELAY 1000  // LED duration for notification

#ifndef RING_BUFFER_SIZE
#define RING_BUFFER_SIZE 56
#endif

module StateMonitorP
{
  provides interface Init;

  uses
  {
    interface Leds;
    interface Notify<button_state_t>;
    interface Timer<TMilli>;

    interface CC2420RadioStateCapture as PowerCapture;
    interface CC2420RadioStateCapture as TxCapture;
    interface CC2420RadioStateCapture as RxCapture;
    interface Counter<TMicro, uint32_t> as Counter;
  }
}
implementation
{
  state_monitor_t monitor_buff[RING_BUFFER_SIZE]; // ring buffer

  norace bool active = FALSE;  // TRUE: debugging mode enabled
  uint8_t read       = 0;      // reading index
  uint8_t write      = 0;      // writting index
  norace uint32_t start_counter;
  uint32_t timestamp;
  uint8_t state;

  /****************************************************************************/
  /****************************************************************************/
  task void print_task()
  {
    if (FALSE == active) { return; }  // debugging mode deactivated
    atomic {
      if (read == write) {
        post print_task(); return;
      }  // nothing to print
    }

    atomic {
      timestamp = monitor_buff[read].r_duration;
      state = monitor_buff[read].r_state;
      read = (read + 1) % RING_BUFFER_SIZE;
    }
    printf("%lu %u\n", timestamp, state);
    post print_task();
  }

  /****************************************************************************/
  /****************************************************************************/
  inline void rb_write(uint8_t val)
  {
    if (FALSE == active) { return; }
    atomic {
      monitor_buff[write].r_state = val;
      monitor_buff[write].r_duration = call Counter.get() - start_counter;
      write = (write + 1) % RING_BUFFER_SIZE;
    }
  }

  /****************************************************************************/
  /****************************************************************************/
  command error_t Init.init()
  {
    call Notify.enable();
    return SUCCESS;
  }

  /****************************************************************************/
  /****************************************************************************/
  event void Notify.notify(button_state_t val)
  {
    if (BUTTON_PRESSED == val) {
      if (FALSE == active) {
        call Leds.led0On();
        printf("Debugging mode activated\n");
        printfflush();
        start_counter = call Counter.get();  // get current timestamp
        active = TRUE;
        post print_task();
      }  // debbuging mode activated
      else {
        call Leds.led2On();
        active = FALSE;
        printf("Debugging mode deactivated\n");
        printfflush();
      }  // deactivated
    }  // button pressed
    call Timer.startOneShot(NOTIFY_DELAY);  // turn off LEDs
  }

  /****************************************************************************/
  /****************************************************************************/
  event void Timer.fired()
  {
    call Leds.led0Off();
    call Leds.led2Off();
  }

  /****************************************************************************/
  /****************************************************************************/
  async event void PowerCapture.captured(uint8_t next_state)
  {
    if (0 == next_state) { call Leds.led1Toggle(); }
    rb_write(next_state);
  }

  /****************************************************************************/
  /****************************************************************************/
  async event void TxCapture.captured(uint8_t next_state)
  {
    rb_write(next_state);
  }

  /****************************************************************************/
  /****************************************************************************/
  async event void RxCapture.captured(uint8_t next_state)
  {
    rb_write(next_state);
  }

  /****************************************************************************/
  /****************************************************************************/
  async event void Counter.overflow()
  {
    call Counter.clearOverflow();
  }
}

