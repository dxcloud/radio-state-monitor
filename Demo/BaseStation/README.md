
Demo/BaseStation/README.md
================================================================================

Directory contents
--------------------------------------------------------------------------------
* README.md
* Makefile
* BaseStationC.nc
* BaseStationP.nc

Description
--------------------------------------------------------------------------------
This application allows to receive report packets from SendingMote application.
It establishes also a serial communication to the PC.
When a packet is received, it sends to the PC that will display the values on
the screen. A java application is required (see *Demo/java* directory) and the
flag **SERIAL_COMM_ENABLED** must be set in the Makefile to start a serial
communication.

**NOTE:** The ID of this mote must be 1. The destination of report packet sent
by sending mote is 1.

Author
--------------------------------------------------------------------------------
Chengwu Huang <chengwhuang@gmail.com>

