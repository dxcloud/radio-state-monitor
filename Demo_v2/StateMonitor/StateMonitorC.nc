/**
 * @file    StateMonitorC.nc
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-07-19
 * @brief   When debugging mode is active, the current radio state is printed
 *          on your terminal with the timestamp.
 */

#ifndef CC2420_RADIO_STATE_CAPTURE
# error \
"*** RADIO STATE CAPTURE DISABLED: component `StateMonitorC' cannot be used ***"
#endif

#if !defined(COUNTER_32KHZ_ENABLED) && !defined(COUNTER_MICRO_ENABLED)
#warning "USING MILLISECOND COUNTER"
#endif

#ifdef COUNTER_32KHZ_ENABLED
#undef COUNTER_MICRO_ENABLED
#warning "*** USING 32KHZ COUNTER ***"
#endif

#ifdef COUNTER_MICRO_ENABLED
#warning "*** USING MICROSECOND COUNTER ***"
#endif

configuration StateMonitorC
{
}
implementation
{
  components MainC;
  components StateMonitorP as Monitor;
  MainC.SoftwareInit -> Monitor.Init;

  components LedsC;
  Monitor.Leds -> LedsC;

  components UserButtonC;
  Monitor.Notify -> UserButtonC;

  components new TimerMilliC() as Timer;
  Monitor.Timer -> Timer;

  components PrintfC, SerialStartC;

  components CC2420ControlC;
  Monitor.PowerCapture -> CC2420ControlC.StateCapture;

  components CC2420ReceiveC;
  Monitor.RxCapture -> CC2420ReceiveC.StateCapture;

  components CC2420TransmitC;
  Monitor.TxCapture -> CC2420TransmitC.StateCapture;

#if defined(COUNTER_32KHZ_ENABLED)
  components Counter32khz32C as Counter;
#elif defined(COUNTER_MICRO_ENABLED)
  components CounterMicro32C as Counter;
#else
  components CounterMilli32C as Counter;
#endif

  Monitor.Counter -> Counter;
}

