################################################################################
### Demo/SendingMote/Makefile
################################################################################

COMPONENT=SendingMoteC

### Low Power Listening
# LPL_WAKEUP_INTERVAL defines the node's radio wakeup interval in milliseconds.
# At the end of each interval, the node will wakeup and check for radio
# activities and then go to OFF mode.
# NOTE: the flag LOW_POWER_LISTENING must be defined
###
CFLAGS += -DLOW_POWER_LISTENING
CFLAGS += -DLPL_WAKEUP_INTERVAL=10000U

### Output power
# CC2420_DEF_RFPOWER indicates the RF output power.
# Possible value are 31, 27, 23, 19, 15, 11, 7, 3
# see CC2420 datasheet (section 28)
###
CFLAGS += -DCC2420_DEF_RFPOWER=31

### Send activity
# Set the flag DUMMY_SEND_ENABLED to allow the sensor to send packets other
# than the report. It will send the packet periodically and the period is
# defined by DUMMY_PERIOD
# If RANDOM_ENABLED is set, the node will send a dummy packet every
# DUMMY_PERIOD + [[0, 4095]]
###
CFLAGS += -DDUMMY_SEND_ENABLED
CFLAGS += -DDUMMY_PERIOD=30000U

#CFLAGS += -DRANDOM_ENABLED

### Acknowledgement policy
# To enable acknowledgement policy, set the flag ACKNOWLEDGEMENT_ENABLED.
# When a report is sent, the mote will wait for an acknowledgement.
# If the packet is NOT acknowledged, the node will send another packet a delay.
# ACK_DELAY defines the delay should the node wait to send another packet.
# MAX_ATTEMPT_SEND is the maximum number of sending of the same packet. When
# this number is reached, the packet will be dropped.
###
#CFLAGS += -DACKNOWLEDGEMENT_ENABLED
#CFLAGS += -DMAX_ATTEMPT_SEND=3
#CFLAGS += -DACK_DELAY=1000U

### CC2420 Radio Parameters
# Define the radio channel
###
CFLAGS += -DCC2420_DEF_CHANNEL=16

### State capture options
# Enable Radio State capture
###
CFLAGS += -DCC2420_RADIO_STATE_CAPTURE

### Printf options
# Enable printf function (for debug purposes)
# When PRINTF_ENABLED is set, the flag NEW_PRINTF_SEMANTICS must also be set
###
CFLAGS += -DPRINTF_ENABLED
CFLAGS += -DNEW_PRINTF_SEMANTICS

### Report interval
# The mote will periodically send a report packet to the Base Station.
# The interval between two report packets is defined by the constant
# REPORT_PERIOD (in milliseconds)
###
CFLAGS += -DREPORT_PERIOD=60000U

### Includes
# Path for report_message.h
###
INCLUDES = -I.. \
           -I../StateCapture \
           -I$(TOSDIR)/lib/printf

CFLAGS += $(INCLUDES)

include $(MAKERULES)

