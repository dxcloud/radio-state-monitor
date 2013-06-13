/**
 * @file   Demo_v2/ReportCmd/ReportCmdC.nc
 * @author Chengwu Huang <chengwhuang@gmail.com>
 * @date   2013-06-07
 * @brief  To use this component, the flag \b CC2420_RADIO_STATE_CAPTURE must
 *         be set.
 */

configuration ReportCmdC
{
}
implementation
{
  components ReportCmdP;
  components new ShellCommandC("report");
  ReportCmdP.ShellCommand -> ShellCommandC;

  components StateCaptureC;
  ReportCmdP.StateCapture -> StateCaptureC;
}

