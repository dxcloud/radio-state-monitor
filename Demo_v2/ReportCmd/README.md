
Demo_v2/ReportCmd/README.md
================================================================================

Directory contents
--------------------------------------------------------------------------------
* README.md
* ReportCmdC.nc
* ReportCmdP.nc

Description
--------------------------------------------------------------------------------
This component is based on 'RoutCmdC', it allows to get the radio activities
report using the udp shell.

    $ nc6 -u fec0::2 2000
    report
    -----off	------pd	----idle	------rx	------tx	---total
    10870250	   16517	   60694	 2376458	  168230	13492149

Author
--------------------------------------------------------------------------------
Chengwu Huang <chengwhuang@gmail.com>

