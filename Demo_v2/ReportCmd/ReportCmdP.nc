/**
 * @file   Demo_v2/ReportCmd/ReportCmdP.nc
 * @author Chengwu Huang <chengwhuang@gmail.com>
 * @date   2013-06-07
 * @brief  Enable to get a radio activity report by using the udp shell.
 */

#include <Shell.h>
#include <CC2420StateCapture.h>

module ReportCmdP
{
  uses interface ShellCommand;
  uses interface StateCapture;
}
implementation
{

  /****************************************************************************/
  /* Event ShellCommand evaluate                                              */
  /****************************************************************************/
  event char* ShellCommand.eval(int argc, char** argv)
  {
    char* ret = call ShellCommand.getBuffer(MAX_REPLY_LEN);
    int i;
    uint32_t total = 0;

    if (ret != NULL) {
      states_t report;
      call StateCapture.getReport(&report);

      for (i = 0; i < NUM_STATES; ++i) {
        total += report.states[i];
      }
      sprintf(ret, "-----off\t------pd\t ----idle\t------rx\t------tx\t---total\n"
                   "%8lu\t%8lu\t%8lu\t%8lu\t%8lu\t%8lu\n",
                   report.states[STATE_OFF],
                   report.states[STATE_PD],
                   report.states[STATE_IDLE],
                   report.states[STATE_RX],
                   report.states[STATE_TX],
                   total);
    }
    return ret;
  }

}

