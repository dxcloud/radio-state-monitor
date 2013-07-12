#include "UserButton.h"


module StateMonitorP
{
  uses
  {
    interface Boot;
    interface Leds;
    interface Notify;
  }
}
implementation
{

  event void Boot.booted()
  {

  }

  event void Notify.notify(button_state_t val)
  {

  }
}

