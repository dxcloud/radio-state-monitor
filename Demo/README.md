
Demo/README.md
================================================================================

Directory contents
--------------------------------------------------------------------------------
* README.md
* report_message.h
* StateCapture (directory)
* SendingMote (directory)
* BaseStation (directory)
* java (directory)
* cc2420 (directory)

Description
--------------------------------------------------------------------------------
### General description
This is the main directory for the demo application. Install several sending
motes and a base station connected to a PC. The behaviour of sending mote can
be modified by some flags.
These application use Active Message, the CC2420 driver has been modified in the
order to include radio event capture.

**NOTE:** A sending mote ID must strictly be greater than 1. ID number 0 and 1
are reserved.

### report_message.h
This header file defines the format of the radio activity report.

### StateCapture
This directory contains the component for capturing radio state and it is used
by the SendingMote application.

See *StateCapture/README.md* for more information.

### SendingMote
This directory provides an application to test the modified CC2420 driver (able
to capture radio state).

See *SendingMote/README.md* for more information.

### BaseStation
For receiving packet from SendingMote application. This application does not
need to use the modified CC2420 driver.

See *BaseStation/README.md* for more information.

### java
This java application is based on PrintfClient application
(*$(TOSROOT)/support/sdk/java/net/tinyos/tools/PrintfClient.java*), it displays
the received packet value on the screen.

See *java/README.md* for more information.

### cc2420
This directory contains the modified CC2420 driver file. Replace the original
directory (located in *$(TOSDIR)/chips*) by this one.
To use the modified driver, define the flag **CC2420_RADIO_STATE_CAPTURE** in
the Makefile of the application.
Think to do a backup of the original directory before replacing it.

Author
--------------------------------------------------------------------------------
Chengwu Huang <chengwhuang@gmail.com>

