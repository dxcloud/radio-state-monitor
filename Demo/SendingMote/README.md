
Demo/SendingMote/README.md
================================================================================

Directory contents
--------------------------------------------------------------------------------
* README.md
* Makefile
* SendingMoteC.nc
* SendingMoteP.nc

Description
--------------------------------------------------------------------------------
### General description
This application is able to collect its radio activities and send a report to
the base station. The interval between two reports is 1 minute (by default),
this interval can be modified by changing the value of **REPORT_PERIOD** (in
milliseconds) in the Makefile.
The LED 1 will toggled whether a packet is successfully sent, otherwise LED 2
will toggled.

**NOTE:** The mote ID must be greater than 2.

### Dummy packets
The mote is also able to send some *dummy packets* so that can change the total
duration of Transmission mode (TX mode). To enable these packets, set the flag
**DUMMY_SEND_ENABLED** in the Makefile. Because these packets are sent periodic
way, the period can be defined by **DUMMY_PERIOD** (the default value 1000 ms).

The flag **RANDOM_ENABLED** is available, a dummy packet will not be sent
periodically. The interval between 2 dummy packets is a value between 0 and
REPORT_PEDIOD.

### Low Power Listening
LPL allows the node to turn off voltage regulator (OFF mode). To allow LPL, use
the flag **LOW_POWER_LISTENING**. The constant **LPL_WAKEUP_INTERVAL** is
defined to change the duty cycle.

### Acknowledgment
If **ACKNOWLEDGEMENT_ENABLED** is set in the Makefile, each report packet
requires an acknowledgement. If the packet is not acknowledged, the mote will
send another one for acknowledgement after a delay. There is a maximum number of
sending, if this number is reached the packet is simply dropped.
In the Makefile, **ACK_DELAY** defines the delay (in milliseconds) to wait 
before sending another packet, and **MAX_ATTEMPT_SEND** is maximum number of
sending. By default, the delay is 1 s and the maximum number of sending is 3.

            (start)
               |
               v
            (i = 0)
               |
               v
         (send report)<---------------------------+
               |                                  | no
               v       no                         |
        (acknowledged?)-->(i = i + 1)-->(i < N ?)-+
               |                            | yes
               | yes                        v
               |                      (drop packet)
               v                            |
             (end)<-------------------------+

        N: number of maximum sending

### Modification
RandomC component is added to provides a generation of a pseudo-random value.

Author
--------------------------------------------------------------------------------
Chengwu Huang <chengwhuang@gmail.com>

