################################################################################
### Demo_v2/SendingMote/Makefile
################################################################################

COMPONENT=SendingMoteC

CFLAGS   += -DCC2420_DEF_CHANNEL=16
CFLAGS   += -DCC2420_DEF_RFPOWER=4

CFLAGS   += -DCC2420_RADIO_STATE_CAPTURE
CFLAGS   += -DIN6_PREFIX=\"fec0::\"

INCLUDES += -I.. \
            -I../StateCapture

CFLAGS   += $(INCLUDES)

include $(MAKERULES)

