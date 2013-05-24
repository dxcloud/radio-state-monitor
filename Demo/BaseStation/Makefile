################################################################################
### Demo/BaseStation/Makefile
################################################################################

COMPONENT=BaseStationC

### CC2420 radio parameters
# Defines the radio channel
CFLAGS += -DCC2420_DEF_CHANNEL=16

### Serial Communication
# When the flag SERIAL_COMM_ENABLED is set, a java application can be used
# (see directory Demo/java)
# NOTE: Prefer Serial communication to printf
CFLAGS += -DSERIAL_COMM_ENABLED

### Printf options
#CFLAGS += -DPRINTF_ENABLED
#CFLAGS += -DNEW_PRINTF_SEMANTICS

### Includes
INCLUDES = -I.. \
           -I$(TOSDIR)/lib/printf

CFLAGS += $(INCLUDES)

include $(MAKERULES)

