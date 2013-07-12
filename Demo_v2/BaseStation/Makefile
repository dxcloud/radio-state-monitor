COMPONENT=BaseStationC

CFLAGS   += -DAPP_PORT=7060

CFLAGS   += -DLED_ENABLED

CFLAGS   += -DCC2420_DEF_CHANNEL=16
CFLAGS   += -DCC2420_DEF_RFPOWER=31

CFLAGS   += -DIN6_PREFIX=\"fec0::\"

CFLAGS   += -DBLIP_DERIVE_SHORTADDRS

CFLAGS   += -DRPL_ROUTING \
            -DRPL_STORING_MODE \
            -I$(TOSDIR)/lib/net/rpl

INCLUDES += -I..

CFLAGS   += $(INCLUDES)

### Enable serial communication between BaseStation and PC
CFLAGS += -DSERIAL_COMM_ENABLED

include $(MAKERULES)

