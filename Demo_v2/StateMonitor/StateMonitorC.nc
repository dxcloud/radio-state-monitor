#ifndef CC2420_RADIO_STATE_CAPTURE
# error \
"*** RADIO STATE CAPTURE DISABLED: component `StateMonitorC' cannot be used ***"
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

  components CounterMicro32C;
  Monitor.Counter -> CounterMicro32C;
}

