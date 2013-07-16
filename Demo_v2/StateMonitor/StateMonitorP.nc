#include "UserButton.h"
#include "Timer.h"
#include "StateMonitor.h"
#include "blip_printf.h"

#define NOTIFY_DELAY 1000  // LED duration for notification

#ifndef RING_BUFFER_SIZE
#define RING_BUFFER_SIZE 255
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

  bool active   = FALSE;  // TRUE: debugging mode enabled
  uint8_t read  = 0;      // reading index
  uint8_t write = 0;      // writting index


  task void print_debug();
  inline void rb_write(uint8_t val);

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
      }  // activate debbuging mode
      else {
        call Leds.led2On();
      }  // deactivate
    }  // button pressed
    call Timer.startOneShot(NOTIFY_DELAY);
  }

  /****************************************************************************/
  /****************************************************************************/
  event void Timer.fired()
  {
    if (FALSE == active) {
      call Leds.led0Off();
      atomic { active = TRUE; }
      printf("Debugging mode activated\n");
    }
    else {
      call Leds.led2Off();
      printf("Debugging mode deactivated\n");
      atomic {
        active = FALSE;
        read = 0;
        write = 0;
      }
    }
    printfflush();
  }

  /****************************************************************************/
  /****************************************************************************/
  async event void PowerCapture.captured(uint8_t next_state)
  {
    if (FALSE == active) { return; }
    rb_write(next_state);
  }

  /****************************************************************************/
  /****************************************************************************/
  async event void TxCapture.captured(uint8_t next_state)
  {
    if (FALSE == active) { return; }
    rb_write(next_state);
  }

  /****************************************************************************/
  /****************************************************************************/
  async event void RxCapture.captured(uint8_t next_state)
  {
    if (FALSE == active) { return; }
    rb_write(next_state);
  }

  /****************************************************************************/
  /****************************************************************************/
  async event void Counter.overflow()
  {
    call Counter.clearOverflow();
  }

  /****************************************************************************/
  /****************************************************************************/
  task void print_debug()
  {
    state_monitor_t tmp;
    atomic {
      tmp = monitor_buff[read];
      read = (read + 1) % RING_BUFFER_SIZE;
    }
    printf("%ld %u\n", tmp.r_duration, tmp.r_state);
    printfflush();
  }

  /****************************************************************************/
  /****************************************************************************/
  void rb_write(uint8_t val)
  {
//    call Leds.led1Toggle();
    atomic {
      monitor_buff[write].r_state = val;
      monitor_buff[write].r_duration = call Counter.get();
      write = (write + 1) % RING_BUFFER_SIZE;
    }
    post print_debug();
  }

}

