/**
 * @file    Demo/StateCapture/StateCaptureC.nc
 * @author  Chengwu Huang <chengwhuang@gmail.com>
 * @date    2013-05-16
 * @version 1.1
 * @brief   
 */

#ifndef CC2420_RADIO_STATE_CAPTURE
#error "*** RADIO STATE CAPTURE DISABLED ***"
#endif

configuration StateCaptureC {
  provides interface StateCapture;
}
implementation {
  components StateCaptureP;
  StateCapture = StateCaptureP.StateCapture;

  components CC2420ControlC;
  StateCaptureP.PowerCapture -> CC2420ControlC.StateCapture;

  components CC2420ReceiveC;
  StateCaptureP.RxCapture -> CC2420ReceiveC.StateCapture;

  components CC2420TransmitC;
  StateCaptureP.TxCapture -> CC2420TransmitC.StateCapture;

  components CounterMicro32C;
  StateCaptureP.Counter -> CounterMicro32C;
}

